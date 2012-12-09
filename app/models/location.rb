class Location < ActiveRecord::Base
  
  acts_as_gmappable
  
  has_many :events
  
  def short_address
    ad = address.sub(/,? New Haven,? /,"")
    ad = ad.sub(/\w\w \d\d\d\d\d/, "")
    ad.strip
  end

  def gmaps4rails_address
    self.address
  end
  
  
end
