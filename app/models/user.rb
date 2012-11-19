class User < ActiveRecord::Base

  # Associations
  has_many :access_controls
  has_many :organizations, :through => :access_controls
  has_many :subscriptions
  has_many :subscribed_organizations, :through => :subscriptions, :source => :subscribeable, :source_type => 'Organization'
  has_many :organization_events, :through => :subscribed_organizations, :source => :events
  has_many :subscribed_categories, :through => :subscriptions, :source => :subscribeable, :source_type => 'Category'
  has_many :category_events, :through => :subscribed_categories, :source => :events
  
  # Subscribed events
  def events
    (self.organization_events + self.category_events).uniq
  end

  # TODO: on_create: if admin of an org, add as subscriber as well
  
end
