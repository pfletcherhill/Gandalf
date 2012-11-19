class Organization < ActiveRecord::Base
  
  # Associations
  has_many :events
  has_many :access_controls

  # To clarify that this should be for admins, the association should be
  # has_many :admins, :class_name => "User", :through => :access_controls
  has_many :users, :through => :access_controls

  has_many :subscriptions, :as => :subscribeable

  # An organization it has a lot of subscribers
  # has_many :subscribers, :through => subscriptions, :class_name => "User"

  # Should an admin automatically become a subscriber?
end
