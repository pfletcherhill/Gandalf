class Event < ActiveRecord::Base
  
  # Associations
  belongs_to :organization
  has_and_belongs_to_many :categories
  
  def date
    date = self.start_at.strftime("%Y-%m-%d")
    date
  end
  
  def as_json
    {
      "id" => id,
      "name" => name,
      "description" => description,
      "location" => location,
      "start_at" => start_at,
      "end_at" => end_at,
      "organization" => organization.name,
      "organization_id" => organization.id,
      "color" => organization.color,
      "categories" => categories
    }
  end
  
end
