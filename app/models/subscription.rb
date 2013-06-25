class Subscription < ActiveRecord::Base
  
  include Gandalf::GoogleApiClient
  
  # Associations
  belongs_to :user
  belongs_to :subscribeable, :polymorphic => true

  # Class methods
  def Subscription.make_slug(name)
    name.downcase.gsub(/ /, "-").gsub(/&/, "and").gsub(/[,\.\)\(:']/, "")
  end
  
end
