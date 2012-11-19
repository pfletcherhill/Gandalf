class Subscription < ActiveRecord::Base
  
  # Associations
  # belongs_to :subscriber, :class_name => "User", :foreign_key => "subscription_id"
  belongs_to :user
  belongs_to :subscribeable, :polymorphic => true
  
end
