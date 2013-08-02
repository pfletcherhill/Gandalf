class Group < ActiveRecord::Base
  
  include Gandalf::Utilities
  include Gandalf::GoogleApiClient
  
  # Associations
  has_many :subscriptions
  has_many :users, through: :subscriptions
  has_many :event_instances
  has_many :events, through: :event_instances
  belongs_to :organization
  
  # Callbacks
  before_validation :set_slug
  # google group is created before create to make sure the group
  # can be reflected in Google land.
  before_create :setup_google_group
  after_create :create_google_counterparts
  after_destroy :destroy_google_counterparts
  after_update :update_google_group
  
  # Validations
  validates_presence_of :name, :slug
  validates_uniqueness_of :name, :case_sensitive => false
  validates_uniqueness_of :slug, :case_sensitive => false
  
  # Methods
  
  def users_with_access(access_type = ACCESS_STATES[:RESTRICTED])
    users.includes(:subscriptions).where("subscriptions.access_type = ?", access_type)
  end
  
  # Uses Gandalf::Utilities make_slug method to convert the group name
  # to a hyphen-separated, lowercase string
  def set_slug
    self.slug = make_slug(name)
  end
  
  # Sets the apps_email attribute according to group naming rule.
  def set_apps_email
    self.apps_email = "yalego.#{self.slug}@tedxyale.com"
  end
  
  def google_rule_id
    "group:#{self.apps_email}"
  end


  # Callbacks

  def create_google_counterparts
    create_google_calendar
    create_google_acl
  end

  def destroy_google_counterparts
    destroy_google_group
    destroy_google_calendar
    # destroy_google_acl
  end
  
  # Google API Methods
  
  # Creates a google group and sets the model's apps_id and apps_email.
  def setup_google_group
    result = Gandalf::GoogleApiClient.insert_google_group({
      "email" => self.apps_email || self.set_apps_email,
      "name" => self.name,
      "description" => self.description
    })
    
    # Checks if a conflict exists in the database.
    if result.status == 409
      result = Gandalf::GoogleApiClient.get_google_group(self.apps_email)
    elsif result.status >= 400
      # Do some error handling...
      return false
    end
    # Set the apps_id and apps_email from the returned object.
    self.apps_id = result.data.id
    self.apps_email = result.data.email
    
  end
  
  def update_google_group
    
  end
  
  # Deletes the google group.
  def destroy_google_group
    result = Gandalf::GoogleApiClient.delete_google_group(self.apps_id)
    result.data
  end
  
  def get_google_group_settings
    result = Gandalf::GoogleApiClient.get_google_group_settings(self.apps_email)
  end
  
  # Uses the insert_google_calendar class method to create a google calendar.
  def create_google_calendar
    unless self.apps_cal_id
      result = Gandalf::GoogleApiClient.insert_google_calendar({
        "summary" => self.name
      })
      self.apps_cal_id = result.data.id
      self.save!
    end
  end
  
  # Uses the get_google_calendar class method to fetch the group's google calendar.
  def get_google_calendar
    result = Gandalf::GoogleApiClient.get_google_calendar(self.apps_cal_id)
    result.data
  end
  
  # Deletes the group's associated calendar
  def destroy_google_calendar
    result = Gandalf::GoogleApiClient.delete_google_calendar(self.apps_cal_id)
    result.data
  end
  
  # Creates a Google access control rule with the apps_cal_id
  # of the group and a reader access control object.
  def create_google_acl
    result = Gandalf::GoogleApiClient.insert_google_acl(self.apps_cal_id, {
      "role" => "reader",
      "scope" => {
        "type" => "group",
        "value" => self.apps_email
      }
    })
    # TODO(rafi): What happens with this data?!?! We need it for the delete
    # method...
    result.data
  end

  def destroy_google_acl
    result = Gandalf::GoogleApiClient.delete_google_acl(self.apps_cal_id)
  end
  
  def get_google_acl
    result = Gandalf::GoogleApiClient.get_google_acl(
      self.apps_cal_id, self.google_rule_id)
    result.data
  end
      
end
