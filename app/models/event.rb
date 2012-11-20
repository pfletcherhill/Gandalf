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
      "id" => read_attribute(:id),
      "name" => read_attribute(:name),
      "description" => read_attribute(:description),
      "location" => read_attribute(:location),
      "start_at" => read_attribute(:start_at),
      "end_at" => read_attribute(:end_at),
      "date" => read_attribute(:start_at).strftime("%Y-%m-%d"),
      "organization" => organization.name
    }
  end
  
end
