class Subscription < ActiveRecord::Base
  
  include Gandalf::Utilities
  include Gandalf::GoogleApiClient
  
  # Associations
  belongs_to :user
  belongs_to :group
  belongs_to :organization

  # Class methods
  def Subscription.make_slug(name)
    name.downcase.gsub(/ /, "-").gsub(/&/, "and").gsub(/[,\.\)\(:']/, "")
  end
  
  # Validations
  validates_presence_of :user_id, :group_id, :access_type
  
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
  
  def get_google_member
    Gandalf::GoogleApiClient.get_google_member(self)
  end
  
end
