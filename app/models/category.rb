class Category < ActiveRecord::Base
  
  # Associations
  has_and_belongs_to_many :events

  has_many :subscriptions, :as => :subscribeable
  has_many :subscribers, :through => :subscriptions, :source => :user
  
end
