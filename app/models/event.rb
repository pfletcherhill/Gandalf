class Event < ActiveRecord::Base

  include Gandalf::GoogleApiClient
  include Gandalf::Utilities
  
  # Associations
  belongs_to :organization
  belongs_to :location
  has_many :event_instances
  has_many :groups, through: :event_instances
  has_many :teams, -> { where type: "Team" }, source: :group, through: :event_instances
  has_many :categories, -> { where type: "Category" }, source: :group, through: :event_instances
  
  validates_presence_of :name, :organization_id, :start_at, :end_at
  validates_uniqueness_of :fb_id, :if => :fb_id?
  validates_uniqueness_of :name, :scope => [:organization_id, :start_at]
  
  # Callbacks
  before_validation :set_slug

  # Search
  include PgSearch
  
  multisearchable against: [
    :name,
    :description
  ]
  
  pg_search_scope :search,
    against: {
      name: "A",
      description: "B"
    },
    associated_against: {
      organization: [:name],
      location: [:name]
    },
    using: {
      tsearch: {
        prefix: true,
        dictionary: "english",
        any_word: true
      }
    }
  
  def set_slug
    self.slug = make_slug(self.name)
  end
  
  def date
    date = self.start_at.strftime("%Y-%m-%d")
    date
  end
  
  def google_start
    { "dateTime" => self.start_at }
  end
  
  def google_end
    { "dateTime" => self.end_at }
  end
  
  def google_location
    "#{self.location.try(:name)}, #{self.location.try(:address)}"
  end
  
  def get_google_event
    result = Gandalf::GoogleApiClient.get_google_event(self.google_calendar_id,
      self.apps_id)
  end

  # Takes an array of category ids and makes them the associated categories
  def set_categories(ids)
    self.categories = Category.find(ids)
    self.save
  end

  def as_json(options={})
    # If no location, then create a dummy location so function returns
    location = self.location || Location.new(
      name: "Unavailable", address: "Unavailable")
    {
      "id" => id,
      "updated_at" => updated_at,
      "name" => name,
      "description" => description,
      "location" => location.name,
      "address" => location.short_address,
      "lat" => location.latitude,
      "lon" => location.longitude,
      "start_at" => start_at,
      "end_at" => end_at,
      "room_number" => room_number, 
      "organization" => organization.name,
      "organization_id" => organization.id,
      "organization_slug" => organization.slug,
      "image" => organization.image.url,
      "thumbnail" => organization.image.thumbnail.url,
      "color" => organization.color,
      "fb_id" => fb_id,
      # Data for rendering calendar with Backbone (hence the camel case)
      "calStart" => start_at,
      "calEnd" => end_at,
      "multiday" => false,
      "eventId" => id
    }
  end
  
  # Class methods

  # Helper method for testing.
  # param {Number=} num Number of events to create.
  # param {Organization=} organization The organization to create the event
  #   for.
  # return {Array.<Event>} The created events.
  def Event.create_upcoming_events(num=5, organization=Organization.first)
    events = []
    num.times do |index|
      e = Event.create!(name: "Event #{index}", organization: organization,
        start_at: Time.now + index.hours,
        end_at: Time.now + (index+2).hours + (index*index*10).minutes)
      organization.followers_team.events << e
      events << e
    end
    return events
  end
  
  def Event.scrape_yale_events(url)
    page = Nokogiri::HTML(open(url))
    events = page.css(".eventList tr")
    date = ""
    yale = Organization.find_or_create_by_name("Yale University")
    events.each do |row|
      first_td = row.css(".dateRow")[0]
      fill_td = row.css(".fillrow")[0]
      # If row is date row
      if first_td
        date = first_td.text
      # If row is empty fill row
      elsif fill_td
        #Do nothing
      else
        time = row.css(".time")[0].text
        # Manipulate time to fit start_at and end_at standards
        if time.include? "All day"
          start_at = DateTime.parse(date)
          end_at = start_at + 1.days
        elsif time.include? "/"
          multiday = true
        elsif time.include? "-"
          time = time.split(" - ")
          start_at = DateTime.parse(date + time[0] + " EST")
          end_at = DateTime.parse(date + time[1] + " EST")
        else
          start_at = DateTime.parse(date + time + " EST")
          end_at = start_at + 1.hour
        end
        # Get title
        title = row.css(".titleEvent")[0].text.gsub(/"/,'')
        # Get description
        description = row.css("ul li")[3].text.gsub(/Description:/,"").strip
        unless multiday
          event = Event.new(:name => title, :start_at => start_at, :end_at => end_at, :description => description)
          event.organization = yale
          # Get location string
          location = row.css("ul li")[1].text.gsub(/Location:\n/,"").strip
          local = Location.where(:name => location).first
          # Search google maps for location
          unless local
            local = Location.new(:name => location)
            local.generate_address
            local.save
          end
          event.location = local
          event.save
          # Get categories array
          categories = row.css(".categoriesEvent a")
          categories.each do |cat|
            cat = cat.text.split(' ').map{|c| c.capitalize }.join(' ')
            category = Category.find_or_generate_by_name(cat)
            event.categories << category
          end
        end
      end
    end
  end
end
