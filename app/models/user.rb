# A User object. May be an admin.

class User < ActiveRecord::Base

  # Associations
  has_many :access_controls
  has_many :organizations, :through => :access_controls
  has_many :subscriptions
  has_many :subscribed_organizations, :through => :subscriptions,
    :source => :subscribeable, :source_type => 'Organization'
  has_many :organization_events, :through => :subscribed_organizations,
    :source => :events
  has_many :subscribed_categories, :through => :subscriptions,
    :source => :subscribeable, :source_type => 'Category'
  has_many :category_events, :through => :subscribed_categories,
    :source => :events

  # Validations
  validates_presence_of :netid, :name, :nickname, :email
  validates_uniqueness_of :netid, :case_sensitive => false
  validates_uniqueness_of :email, :case_sensitive => false
  
  # Get a user's subscribed events.
  # param {string, string, ...} *times Optional two time strings, formatted
  #   as Rails timestamps, specifying start and end times respectively.
  #   If only one is provided, only the start time is specified.
  # return {[Event]} An array of events that the user follows that also 
  #   matching the times.
  def events(*times)
    start_at = times[0]
    end_at = times[1]
    if start_at && end_at
      start_at = Date.strptime(start_at, '%m-%d-%Y')
      end_at = Date.strptime(end_at, '%m-%d-%Y')
      query = "start_at < :end AND end_at > :start"
      organization_events = 
        self.organization_events
          .where(query,{ :start => start_at, :end => end_at })
          .includes(:location, :organization, :categories)
      category_events = 
        self.category_events
          .where(query, { :start => start_at, :end => end_at })
          .includes(:location, :organization, :categories)
    else
      organization_events = self.organization_events
      category_events = self.category_events
    end
    events = (organization_events + category_events).uniq
    # events are sorted clientside
    events
  end

  # Returns limit number of events ending after the current time. 
  # If offset is specified, then gets <limit> items after
  # the first <offset> (for pagination.)
  # param {number} limit The maximum number of events to return.
  # param {number=} offset The number of next events to skip before
  #   counting towards limit.
  def next_events(limit, offset=0)
    # offset = opt_offset || 0
    query = "end_at > :now"
    organization_events = 
        self.organization_events
          .where(query, {now: Time.now })
          .limit(limit)
          .includes(:location, :organization, :categories)
    cateogory_events = 
      self.category_events
        .where(query, {now: Time.now })
        .limit(limit)
        .includes(:location, :organization, :categories)
    events = (organization_events + category_events).uniq
  end

  def upcoming_events(start=Time.now, limit=10)
    o_events = 
      self.organization_events
        .where("start_at > ?", start)
        .includes(:location, :organization, :categories)
        .order("start_at")
        .limit(limit)
    c_events = 
      self.category_events
        .where("start_at > ?", start)
        .includes(:location, :organization, :categories)
        .order("start_at")
        .limit(limit)

    events = (o_events + c_events).uniq.sort_by { |e| e.start_at }
    events.take(limit)
  end

  def as_json (options)
    {
      "id" => id,
      "name" => name,
      "email" => email,
      "nickname" => nickname,
      "college" => college,
      "year" => year,
      "organizations" => organizations,
      "bulletin_preference" => bulletin_preference,
      "fb_id" => self.fb_id,
      "fb_access_token" => fb_access_token,
      "fb_accounts" => fb_accounts
    }
  end
  
  # Authorization methods
  
  def has_authorization_to(organization)
    access_control = AccessControl.where(:organization_id => organization.id, :user_id => self.id).first
    if access_control
      return true
    else
      return false
    end
  end
  
  def add_authorization_to(organization)
    self.organizations << organization
    self.subscribed_organizations << organization
  end
  
  def remove_authorization_to(organization)
    access = AccessControl.where(:organization_id => organization.id, :user_id => self.id).first
    access.destroy
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
  
  # Class methods

  def User.send_daily_bulletin
    User.where(bulletin_preference: "daily").find_each do |user|
      UserMailer.bulletin(user, "daily").deliver
    end
  end

  def User.send_weekly_bulletin
    User.where(bulletin_preference: "weekly").find_each do |user|
      UserMailer.bulletin(user, "weekly").deliver
    end
  end
      
  def User.create_from_directory(id, type="uid", search=false)
    if search
      u = nil
      u = case type
        when "uid" then User.find_by_netid(id)
        when "email" then User.find_by_email(id)
      end
      return u if u
    end

    User.update_browser

    netid_regex = /^NetID:/
    name_regex = /^Name:/
    known_as_regex = /Known As:/
    email_regex = /Email Address:/
    college_regex = /Residential College:/
    year_regex = /Class Year:/
    division_regex = /Division:/

    url = "http://directory.yale.edu/phonebook/index.htm?searchString=#{type}%3D#{id}"
    @@browser.get(url)

    u = User.new
    # u.netid = netid
    @@browser.page.search('tr').each do |tr|
      field = tr.at('th').text.strip
      value = tr.at('td').text.strip
      case field
      when netid_regex
        u.netid = value
      when name_regex
        u.name = value
      when known_as_regex
        u.nickname = value
      when email_regex
        u.email = value
      when college_regex
        u.college = value
      when year_regex
        u.year = value
      when division_regex
        u.division = value
      end
    end
    if u.email # If a user was found
      u.name ||= User.name_from_email(u.email)  # Make sure of name
      u.nickname = u.name.split(" ").first      # Set nickname
      if u.save
        return u
      else
        return nil
      end
    else
      return nil
    end

  end

  def User.name_from_email(email)
    e = email.gsub(/@yale.edu/, "")
    names = e.split(".")
    names.map! { |n| n.gsub(/(\b|-)(\w)/) { |s| s.upcase } }
    names.join(" ")
  end

  def User.make_cas_browser
    browser = Mechanize.new
    browser.get( 'https://secure.its.yale.edu/cas/login' )
    form = browser.page.forms.first
    form.username = ENV['CAS_NETID']
    form.password = ENV['CAS_PASS']
    form.submit
    browser
  end

  # Make sure CAS credentials don't expire by refreshing every hour
  def User.update_browser
    if Time.now - @@browser_time > 1.hour
      @@browser = user.make_cas_browser
    end
  end

  # Keep a CAS_authenticated browser
  @@browser = User.make_cas_browser
  @@browser_time = Time.now

end
