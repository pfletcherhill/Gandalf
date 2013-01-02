class Organization < ActiveRecord::Base
  
  # Associations
  has_many :events
  has_many :access_controls
  has_many :admins, :through => :access_controls, :source => :user
  has_many :subscriptions, :as => :subscribeable
  has_many :subscribers, :through => :subscriptions, :source => :user

  # Validations
  validates_uniqueness_of :name, :case_sensitive => false
  
  
  #pg_search
  include PgSearch
  multisearchable :against => [:name, :bio]
  pg_search_scope :fulltext_search, 
                  :against => [:name, :bio], 
                  :using => { :tsearch => {:prefix => true} }
                  
  #Image Uploader
  mount_uploader :image, ImageUploader
      
  #Events, can have start and end
  def events_with_period(*times)
    start_at = times[0]
    end_at = times[1]
    if start_at && end_at
      start_at = Date.strptime(start_at, '%m-%d-%Y')
      end_at = Date.strptime(end_at, '%m-%d-%Y')
      query = "start_at BETWEEN :start AND :end OR end_at BETWEEN :start AND :end"
      @events = self.events.where(query,
        { :start => start_at, :end => end_at })
    else
      @events = self.events
    end
    @events
  end
  
  #Categories, sorted by most frequent
  def categories
    events = self.events
    categories = events.map{|event| event.categories}.flatten
    categories.uniq.sort_by{ |c| categories.grep(c).size }.reverse
  end

end
