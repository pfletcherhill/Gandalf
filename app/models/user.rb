class User < ActiveRecord::Base
  
  #Associations
  has_many :access_controls
  has_many :organizations, :through => :access_controls
  has_many :subscriptions
  has_many :subscribeable_organizations, :through => :subscriptions, :source => :subscribeable, :source_type => 'Organization'
  has_many :organization_events, :through => :subscribeable_organizations, :source => :events
  has_many :subscribeable_categories, :through => :subscriptions, :source => :subscribeable, :source_type => 'Category'
  has_many :category_events, :through => :subscribeable_categories, :source => :events
  
  #Subscribed events
  def events
    (self.organization_events + self.category_events).uniq
  end
  
end
