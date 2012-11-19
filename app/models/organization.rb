class Organization < ActiveRecord::Base
  
  # Associations
  has_many :events
  has_many :access_controls
  has_many :users, :through => :access_controls
  has_many :subscriptions, :as => :subscribeable
end
