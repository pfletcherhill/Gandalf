class Subscription < ActiveRecord::Base
  
  #Associations
  belongs_to :user
  belongs_to :subscribeable, :polymorphic => true
  
end
