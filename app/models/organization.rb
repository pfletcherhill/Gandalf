class Organization < ActiveRecord::Base
  
  # Associations
  has_many :events
  has_many :access_controls

  # To clarify that this should be for admins, the association should be
  # has_many :admins, :class_name => "User", :through => :access_controls
  has_many :admins, :through => :access_controls, :source => :user

  has_many :subscriptions, :as => :subscribeable
  has_many :subscribers, :through => :subscriptions, :source => :user

end
