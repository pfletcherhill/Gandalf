class User < ActiveRecord::Base


  # Associations
  has_many :access_controls
  has_many :organizations, :through => :access_controls
  has_many :organization_subscriptions
  has_many :subscribed_organizations, :through => :organization_subscriptions, :source => :organization
  has_many :organization_events, :through => :subscribed_organizations, :source => :events
  has_many :category_subscriptions
  has_many :subscribed_categories, :through => :category_subscriptions, :source => :category
  has_many :category_events, :through => :subscribed_categories, :source => :events

  def events
    (self.organization_events + self.category_events).uniq
  end
  
end
