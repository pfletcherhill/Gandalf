class Subscription < ActiveRecord::Base
  
  include Gandalf::Utilities
  include Gandalf::GoogleApiClient
  
  # Associations
  belongs_to :user
  belongs_to :group
  belongs_to :subscribeable, :polymorphic => true
  
  # Validations
  validates_presence_of :user_id, :group_id, :subscribeable_id, :subscribeable_type
  
  # Callbacks
  after_create :create_google_member
  
  # Methods
  
  def google_role
    case self.access_type
    when ACCESS_STATES['FOLLOWER']
      "MEMBER"
    when ACCESS_STATES['MEMBER']
      "MEMBER"
    when ACCESS_STATES['ADMIN']
      "OWNER"
    end
  end
  
  # Google API Methods
  
  def create_google_member
    Gandalf::GoogleApiClient.insert_google_member(self.group.apps_id, {
      "email" => self.user.email,
      "role" => self.google_role
    })
  end
  
end
