class Subscription < ActiveRecord::Base
  
  # Associations
  belongs_to :user
  belongs_to :subscribeable, :polymorphic => true

  def Subscription.make_slug(name)
    name.downcase.gsub(/ /, "-").gsub(/&/, "and").gsub(/[,\.\)\(:']/, "")
  end
  
end
