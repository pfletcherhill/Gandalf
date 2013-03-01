class User < ActiveRecord::Base

  # Associations
  has_many :access_controls
  has_many :organizations, :through => :access_controls
  has_many :subscriptions
  has_many :subscribed_organizations, :through => :subscriptions, :source => :subscribeable, :source_type => 'Organization'
  has_many :organization_events, :through => :subscribed_organizations, :source => :events
  has_many :subscribed_categories, :through => :subscriptions, :source => :subscribeable, :source_type => 'Category'
  has_many :category_events, :through => :subscribed_categories, :source => :events

  # Validations
  validates_presence_of :netid, :name, :nickname, :email
  validates_uniqueness_of :netid, :case_sensitive => false
  validates_uniqueness_of :email, :case_sensitive => false
  
  # Subscribed events
  def events(*times)
    start_at = times[0]
    end_at = times[1]
    if start_at && end_at
      start_at = Date.strptime(start_at, '%m-%d-%Y')
      end_at = Date.strptime(end_at, '%m-%d-%Y')
      query = "start_at < :end AND end_at > :start"
      organization_events = 
        self.organization_events
          .includes(:location, :organization, :categories)
          .where(query,{ :start => start_at, :end => end_at })
      category_events = 
        self.category_events
          .includes(:location, :organization, :categories)
          .where(query, { :start => start_at, :end => end_at })
    else
      organization_events = self.organization_events
      category_events = self.category_events
    end
    events = (organization_events + category_events).uniq
    # events are sorted clientside
    events
  end

  # TODO: on_create: if admin of an org, add as subscriber as well
  def as_json
    {
      "id" => id,
      "name" => name,
      "email" => email,
      "nickname" => nickname,
      "college" => college,
      "year" => year,
      "organizations" => organizations
    }
  end
  
  def has_authorization_to(organization)
    access_control = AccessControl.where(:organization_id => organization.id, :user_id => self.id).first
    if access_control
      return true
    else
      return false
    end
  end
  
  def User.create_from_directory(netid)
    name_regex = /^\s+Name:/
    known_as_regex = /Known As:/
    email_regex = /Email Address:/
    college_regex = /Residential College:/
    year_regex = /Class Year:/
    division_regex = /Division:/

    browser = User.make_cas_browser
    browser.get("http://directory.yale.edu/phonebook/index.htm?searchString=uid%3D#{netid}")

    u = User.new
    u.netid = netid
    browser.page.search('tr').each do |tr|
      field = tr.at('th').text
      value = tr.at('td').text.strip
      case field
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
    u.nickname = u.name.split(" ").first if not u.nickname
    u.save!
    u
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

end
