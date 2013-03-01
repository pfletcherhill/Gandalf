class Location < ActiveRecord::Base
  
  before_save :generate_address
  
  has_many :events
  
  validates_presence_of :name
  
  acts_as_gmappable
  
  def short_address
    ad = address.sub(/,? New Haven,? /,"")
    ad = ad.sub(/\w\w \d\d\d\d\d/, "")
    ad.strip
  end

  def gmaps4rails_address
    self.address
  end
  
  # Generates address, longitude, and latitude from google maps
  def generate_address
    name = self.name
    unless self.address
      key = "AIzaSyDxC7qcloU94l5dvOEdAoQTZ7AijIX65gw"
      search = name.gsub(" ","+")
      map_results = JSON.parse(open(
        "https://maps.googleapis.com/maps/api/place/textsearch/json?location=41.310362,-72.928914&radius=500&key=#{key}&query=#{search}&sensor=true").read)
      loc = map_results['results'].first
      if loc
        address = loc["formatted_address"]
        lat = loc["geometry"]["location"]["lat"]
        lng = loc["geometry"]["location"]["lng"]
      else
        address = "38 Hillhouse Avenue, New Haven, CT 06511"
        lat = "41.310362"
        lng = "-72.928914"
      end
      self.attributes = {:address => address, :latitude => lat, :longitude => lng}
    end
  end
end
