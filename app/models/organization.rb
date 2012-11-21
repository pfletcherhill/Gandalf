class Organization < ActiveRecord::Base
  
  # Associations
  has_many :events
  has_many :access_controls
  has_many :admins, :through => :access_controls, :source => :user
  has_many :subscriptions, :as => :subscribeable
  has_many :subscribers, :through => :subscriptions, :source => :user

  validates_uniqueness_of :name, :case_sensitive => false

end
