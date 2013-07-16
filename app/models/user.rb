# A User object. May be an admin.

class User < ActiveRecord::Base

  include Gandalf::Utilities
  include Gandalf::GoogleApiClient
  
  # Associations
  has_many :subscriptions, dependent: :destroy
  has_many :groups, through: :subscriptions
  has_many :events, through: :groups
  
  # Calendars
  has_many :subscribed_teams, -> { where type: "Team" },
           through: :subscriptions,
           source: :group
  has_many :team_events,
           through: :subscribed_teams,
           source: :events
  
  # Categories
  has_many :subscribed_categories, -> { where type: "Category" },
           through: :subscriptions,
           source: :group
  has_many :category_events,
           through: :subscribed_categories,
           source: :events

  # Organizations
  has_many :subscribed_organizations,
           through: :subscribed_teams,
           source: :organization
                    
  # Access Controls
  has_many :admin_organizations, -> { where 'subscriptions.access_type = ?', ACCESS_STATES[:ADMIN] },
           through: :subscribed_teams,
           source: :organization
  has_many :member_organizations, -> { where 'subscriptions.access_type = ?', ACCESS_STATES[:MEMBER] },
           through: :subscribed_teams,
           source: :organization
  has_many :follower_organizations, -> { where 'subscriptions.access_type = ?', ACCESS_STATES[:FOLLOWER] or nil },
           through: :subscribed_teams,
           source: :organization

  # Validations
  validates_presence_of :netid, :name, :email
  validates_uniqueness_of :netid, :case_sensitive => false
  validates_uniqueness_of :email, :case_sensitive => false
  
  # Constants
  NETID_REGEX = /^NetID:/
  NAME_REGEX = /^Name:/
  KNOWN_AS_REGEX = /Known As:/
  EMAIL_REGEX = /Email Address:/
  COLLEGE_REGEX = /Residential College:/
  YEAR_REGEX = /Class Year:/
  DIVISION_REGEX = /Division:/
  
  def display_name
    nickname || name
  end
  
  def organizations
    self.admin_organizations
  end
  
  # Get a user's subscribed events.
  # param {string, string, ...} *times Optional two time strings, formatted
  #   as Rails timestamps, specifying start and end times respectively.
  #   If only one is provided, only the start time is specified.
  # return {[Event]} An array of events that the user follows that also 
  #   matching the times.
  def events_with_range(*times)
    start_at = times[0]
    end_at = times[1]
    if start_at && end_at
      start_at = Date.strptime(start_at, '%m-%d-%Y')
      end_at = Date.strptime(end_at, '%m-%d-%Y')
      query = "start_at < :end AND end_at > :start"
      events.where(query,{ :start => start_at, :end => end_at }).includes(:location, :organization, :categories).uniq
    else
      events.uniq
    end
  end
  
  # Returns limit number of events ending after the current time. 
  # If offset is specified, then gets <limit> items after
  # the first <offset> (for pagination.)
  # param {datetime} start The maximum number of events to return.
  # param {number} limit The maximum number of events to return.
  # param {number=} offset The number of next events to skip before
  #   counting towards limit.
  def next_events(*options)
    start = options.try(:start) || Time.now
    limit = options.try(:limit) || 20
    offset = options.try(:offset) || 0
    query = "end_at > :start"
    self.events.limit(limit).where(query, {start: start})
                            .order("start_at")
                            .includes(:location, :organization)
                            .uniq
  end

  def as_json (*options)
    {
      "id" => id,
      "name" => name,
      "email" => email,
      "nickname" => nickname,
      "college" => college,
      "year" => year,
      "organizations" => organizations,
      "subscribed_organizations" => subscribed_organizations,
      "teams" => subscribed_teams,
      "categories" => subscribed_categories,
      "bulletin_preference" => bulletin_preference,
      "fb_id" => self.fb_id,
      "fb_access_token" => fb_access_token,
      "fb_accounts" => fb_accounts
    }
  end
  
  # Group methods
  
  def subscribe_to(group_id, access_type = 0)
    group = Group.find(group_id)
    Subscription.create(user_id: self.id, group_id: group_id, access_type: access_type)
  end
  
  def unsubscribe_from(group_id)
    subscription = Subscription.where(user_id: self.id, group_id: group_id).first
    subscription.destroy if subscription
  end
  
  # Authorization methods
  
  def has_authorization_to(organization)
    organization_ids = self.admin_organizations.map{|org| org.id}
    if organization_ids.include? organization.id
      return true
    else
      return false
    end
  end
  
  def add_authorization_to(organization)
    # self.admin_organizations << organization
    #     self.subscribed_organizations << organization
  end
  
  def remove_authorization_to(organization)
    # access = AccessControl.where(:organization_id => organization.id, :user_id => self.id).first
    #     access.destroy
  end

  # Admin methods
  
  def promote
    self.admin = true
    self.save
  end
  
  def demote
    self.admin = false
    self.save
  end
  
  def administers_organizations?
    self.admin_organizations.count > 0
  end
  
  # Class methods

  def self.send_daily_bulletin
    User.where(bulletin_preference: "daily").find_each do |user|
      UserMailer.bulletin(user, "daily").deliver
    end
  end

  def self.send_weekly_bulletin
    User.where(bulletin_preference: "weekly").find_each do |user|
      UserMailer.bulletin(user, "weekly").deliver
    end
  end

  def self.name_from_email(email)
    e = email.gsub(/@yale.edu/, "")
    names = e.split(".")
    names.map! { |n| n.gsub(/(\b|-)(\w)/) { |s| s.upcase } }
    names.join(" ")
  end
  
  def promote
    self.admin = true
    self.save
  end
  
  def demote
    self.admin = false
    self.save
  end
      
  def self.create_from_directory(id, type="uid")
    
    browser = Gandalf::Utilities.make_cas_browser
    browser.get("http://directory.yale.edu/phonebook/index.htm?searchString=#{type}%3D#{id}")

    user = User.new
    browser.page.search('tr').each do |tr|
      field = tr.at('th').text.strip
      value = tr.at('td').text.strip
      case field
      when NETID_REGEX
        user.netid = value
      when NAME_REGEX
        user.name = value
      when KNOWN_AS_REGEX
        user.nickname = value
      when EMAIL_REGEX
        user.email = value
      when COLLEGE_REGEX
        user.college = value
      when YEAR_REGEX
        user.year = value
      when DIVISION_REGEX
        user.division = value
      end
    end
        
    if user.email # If a user was found
      user.name ||= User.name_from_email(user.email)  # Make sure of name
      user.nickname = user.name.split(" ").first      # Set nickname
      if user.save
        return user
      else
        return nil
      end
    else
      return nil
    end
  end

end
