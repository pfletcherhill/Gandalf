class User < ActiveRecord::Base
  
  #Associations
  has_many :access_controls
  has_many :organizations, :through => :access_controls
  has_many :subscriptions
  has_many :subscribeable_organizations, :through => :subscriptions, :source => :subscribeable, :source_type => 'Organization'
  has_many :subscribeable_categories, :through => :subscriptions, :source => :subscribeable, :source_type => 'Category'
  
  #Subscribed events
  def events
    events = Array.new
    self.subscribeable_organizations.map{|s| s.events}.each do |event|
      events << event
    end
    self.subscribeable_categories.map{|s| s.events}.each do |event|
      events << event
    end
    events.first
  end
  
end
