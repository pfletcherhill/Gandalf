class Event < ActiveRecord::Base
  
  # Associations
  belongs_to :organization
  has_and_belongs_to_many :categories
  
  def date
    date = self.start_at.strftime("%Y-%m-%d")
    date
  end

  def short_address
    ad = address.sub(/,? New Haven,? /,"")
    ad = ad.sub(/\w\w \d\d\d\d\d/, "")
    ad.strip
  end
  
  def as_json
    {
      "id" => id,
      "name" => name,
      "description" => description,
      "location" => location,
      "address" => short_address,
      "start_at" => start_at,
      "end_at" => end_at,
      "organization" => organization.name,
      "organization_id" => organization.id,
      "color" => organization.color,
      "categories" => categories
    }
  end
  
end
