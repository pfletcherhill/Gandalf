class Category < ActiveRecord::Base
  
  #Associations
  has_many :category_subscriptions
  has_many :followers, :class_name => "User", :through => :category_subscription
  has_and_belongs_to_many :events
  
end
