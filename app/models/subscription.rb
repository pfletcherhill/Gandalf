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
  validates_uniqueness_of :user_id, scope: [:group_id]
  
  # Callbacks
  after_create :create_google_member
  after_destroy :destroy_google_member
  
  # Methods
  
  def google_role
    if self.access_type == ACCESS_STATES['WRITE']
      "OWNER"
    else
      "MEMBER"
    end
  end
  
  # Google API Methods
  
  def create_google_member
    Gandalf::GoogleApiClient.insert_google_member(self.group.apps_id, {
      "email" => self.user.email,
      "role" => self.google_role
    })
  end
  
  def destroy_google_member
    # pending
  end
  
  def get_google_member
    Gandalf::GoogleApiClient.get_google_member(self)
  end
  
end
