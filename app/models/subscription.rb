class Subscription < ActiveRecord::Base
  
  include Gandalf::Utilities
  include Gandalf::GoogleApiClient
  
  # Associations
  belongs_to :user
  belongs_to :group
  belongs_to :subscribeable, :polymorphic => true
  
  # Callbacks
  before_create :set_slug
  
  # Methods
  def set_slug
    slug = make_slug(name)
  end
  
end
