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
  
end
