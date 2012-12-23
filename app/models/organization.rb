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

end
