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
  has_many :organization_events, :through => :subscribeable_organizations, :source => :events
  has_many :subscribeable_categories, :through => :subscriptions, :source => :subscribeable, :source_type => 'Category'
  has_many :category_events, :through => :subscribeable_categories, :source => :events
  
  # Subscribed events
  def events
    (self.organization_events + self.category_events).uniq
  end
  
end
