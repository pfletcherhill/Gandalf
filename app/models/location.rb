class Location < ActiveRecord::Base

  include Gandalf::GoogleApiClient
  
  before_save :generate_address

  has_many :events
  has_many :location_aliases

  validates_presence_of :name
  validates_uniqueness_of :name

  acts_as_gmappable

  include PgSearch
  multisearchable :against => [:name]
  pg_search_scope :name_search, 
    against: [:name, :address],
    associated_against: { location_aliases: :value },
    using: { tsearch: { 
      prefix: true, 
      any_word: true
   } }

  def short_address
    # Remove state and zipcode
    ad = address.sub(/\w\w \d\d\d\d\d/, "")
    ad = ad.gsub(/(,? New Haven,? |CT,?|United States)/,"")
    ad.strip
  end

  def gmaps4rails_address
    self.address
  end

  # Generates address, longitude, and latitude from google maps
  def generate_address
    name = self.name
    unless self.address
      key = ENV['GMAPS_KEY']
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

  def Location.sanitize(string)
    string.gsub(/[\.,]/, "")
  end
end
