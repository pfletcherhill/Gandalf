class Event < ActiveRecord::Base

  # Associations
  belongs_to :organization
  has_and_belongs_to_many :categories
  belongs_to :location

  validates_presence_of :name
  validates_presence_of :organization_id
  validates_presence_of :start_at
  validates_presence_of :end_at

  #pg_search
  include PgSearch
  multisearchable :against => [:name, :description]
  pg_search_scope :fulltext_search,
                  :against => [:name, :description],
                  :associated_against => {
                    :organization => [:name],
                    :location => [:name]
                  },
                  :using => { :tsearch => {:prefix => true} }

  # todo: before save convert to UTC and check that before < after

  def date
    date = self.start_at.strftime("%Y-%m-%d")
    date
  end

  def as_json
    # If no location, then create a dummy location so function returns
    location = self.location || Location.new(
      name: "Unavailable", address: "Unavailable")
    {
      "id" => id,
      "name" => name,
      "description" => description,
      "location" => location.name,
      "address" => location.short_address,
      "lat" => location.latitude,
      "lon" => location.longitude,
      "start_at" => start_at,
      "end_at" => end_at,
      "organization" => organization.name,
      "organization_id" => organization.id,
      "color" => organization.color,
      "categories" => categories,
      # Data for rendering calendar with Backbone (hence the camel case)
      "calStart" => start_at,
      "calEnd" => end_at,
      "multiday" => false,
      "eventId" => id
    }
  end

end
