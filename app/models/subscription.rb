class Subscription < ActiveRecord::Base
  
  include Gandalf::Utilities
  include Gandalf::GoogleApiClient
  
  # Associations
  belongs_to :user
  belongs_to :group
  belongs_to :subscribeable, :polymorphic => true
  
  # Validations
  validates_presence_of :user_id, :group_id, :subscribeable_id, :subscribeable_type
  
end
