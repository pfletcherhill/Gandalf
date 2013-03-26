class Event < ActiveRecord::Base

  # Associations
  belongs_to :organization
  has_and_belongs_to_many :categories
  belongs_to :location

  validates_presence_of :name
  validates_presence_of :organization_id
  validates_presence_of :start_at
  validates_presence_of :end_at

  validates_uniqueness_of :fb_id, :if => :fb_id?
  validates_uniqueness_of :name, :scope => [:organization_id, :start_at]

  #pg_search
  include PgSearch
  multisearchable :against => [:name, :description]
  pg_search_scope :fulltext_search,
    against: [:name, :description],
    associated_against: {
      organization: [:name],
      location: [:name]
    },
    using: { tsearch: {
      prefix: true, 
      dictionary: "english",
      any_word: true
    }
  }

  def date
    date = self.start_at.strftime("%Y-%m-%d")
    date
  end

  # Takes an array of category ids and makes them the associated categories
  def set_categories(ids)
    self.categories = []
    if ids
      ids.each do |id|
        self.categories << Category.find(id)
      end
    end
  end

  def as_json(options)
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
      "categories" => categories,
      "fb_id" => fb_id,
      # Data for rendering calendar with Backbone (hence the camel case)
      "calStart" => start_at,
      "calEnd" => end_at,
      "multiday" => false,
      "eventId" => id
    }
  end
  
  # Class methods
  
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
          start_at = DateTime.parse(date + time[0])
          end_at = DateTime.parse(date + time[1])
        else
          start_at = DateTime.parse(date + time)
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
