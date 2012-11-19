class User < ActiveRecord::Base

  # Associations
  has_many :access_controls
  # Is an admin of many organizations
  has_many :organizations, :through => :access_controls
  has_many :subscriptions
  # should be 
  # has_many :events, :through => :subscriptions
  # otherwise, we the whole polymorphic thing isn't being used
  has_many :subscribeable_organizations, :through => :subscriptions, :source => :subscribeable, :source_type => 'Organization'
  has_many :subscribeable_categories, :through => :subscriptions, :source => :subscribeable, :source_type => 'Category'
  
  # Subscribed events
  def events
    (self.subscribeable_organizations.events + self.subscribeable_categories.events).uniq
  end
  
end
