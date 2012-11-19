class Organization < ActiveRecord::Base
  
  # Associations
  has_many :organization_subscription
  has_many :followers, :class_name => "User", :through => :organization_subscription
  has_many :access_controls
  has_many :members, :class_name => "User", :through => :access_controls
  has_many :events
  
end
