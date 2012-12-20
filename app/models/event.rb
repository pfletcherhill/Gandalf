class Event < ActiveRecord::Base

  # Associations
  belongs_to :organization
  has_and_belongs_to_many :categories
  belongs_to :location
  
  validates_presence_of :name
  validates_presence_of :organization_id
  validates_presence_of :start_at

  # todo: before save convert to UTC and check that before < after
  
  def date
    date = self.start_at.strftime("%Y-%m-%d")
    date
  end
  
  def as_json
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
      # Data for rendering calendar (hence the camel case)
      "calStart" => start_at,
      "calEnd" => end_at,
      "multiday" => false,
      "eventId" => id
    }
  end
  
end
