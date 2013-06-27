class Subscription < ActiveRecord::Base
  
  include Gandalf::Utilities
  include Gandalf::GoogleApiClient
  
  # Associations
  belongs_to :user
  belongs_to :group
  belongs_to :subscribeable, :polymorphic => true
  
end
