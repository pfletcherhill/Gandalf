class Category < ActiveRecord::Base
  
  # Associations
  has_and_belongs_to_many :events
  has_many :subscriptions, :as => :subscribeable
  has_many :subscribers, :through => :subscriptions, :source => :user
  
  #pg_search
  include PgSearch
  multisearchable :against => [:name, :description]
  pg_search_scope :fulltext_search, 
                  :against => [:name, :description], 
                  :using => { :tsearch => {:prefix => true} }
  
  #Events, can have start and end
  def events_with_period(*times)
    start_at = times[0]
    end_at = times[1]
    if start_at && end_at
      start_at = Date.strptime(start_at, '%m-%d-%Y')
      end_at = Date.strptime(end_at, '%m-%d-%Y')
      query = "start_at BETWEEN :start AND :end OR end_at BETWEEN :start AND :end"
      query = "start_at < :end AND end_at > :start"
      @events = self.events.where(query,
        { :start => start_at, :end => end_at })
    else
      @events = self.events
    end
    @events
  end
  
end
