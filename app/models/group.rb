class Group < ActiveRecord::Base
  
  include Gandalf::Utilities
  include Gandalf::GoogleApiClient
  
  # Associations
  has_many :events, foreign_key: "calendar_id"
  belongs_to :groupable, polymorphic: true
  
  # Callbacks
  before_validation :set_slug
  before_create :set_apps_email
  before_create :setup_google_group
  after_create :create_google_calendar
  after_destroy :destroy_google_calendar
  after_destroy :destroy_google_group
  
  # Validations
  validates_presence_of :name, :slug, :groupable_id, :groupable_type
  
  # Methods
  
  # set_slug uses Gandalf::Utilities make_slug
  # method to convert the group name to a hyphen-separated,
  # lowercase string
  def set_slug
    self.slug = make_slug(name)
  end
  
  def set_apps_email
    self.apps_email = "yalego.#{self.slug}@tedxyale.com"
  end
  
  # Google API Group Methods
  
  # setup_google_group creates a google group and sets the model's
  # apps_id and apps_email
  def setup_google_group
    
    result = Gandalf::GoogleApiClient.insert_google_group({
      "email" => self.apps_email || self.set_apps_email,
      "name" => self.name,
      "description" => self.description
    })
    
    # If a conflict exists in the database
    if result.status == 409
      result = Gandalf::GoogleApiClient.get_google_group(self.apps_email)
    end
    
    # Set the apps_id and apps_email from the returned object
    self.apps_id = result.data.id
    self.apps_email = result.data.email
    
  end
  
  # destroy_google_group deletes the google group
  def destroy_google_group
    result = Gandalf::GoogleApiClient.delete_google_group(self.apps_id)
  end
  
  # create_google_calendar uses the insert_google_calendar
  # class method to create a google calendar
  def create_google_calendar
    unless self.apps_cal_id
      result = Gandalf::GoogleApiClient.insert_google_calendar({
        "summary" => self.name
      })
    
      self.apps_cal_id = result.data.id
      self.save
    end
  end
  
  # get_google_calendar uses the get_google_calendar
  # class method to fetch the group's google calendar
  def get_google_calendar
    Gandalf::GoogleApiClient.get_google_calendar(self.apps_cal_id)
  end
  
  # destroy_google_calendar deletes the group's associated calendar
  def destroy_google_calendar
    result = Gandalf::GoogleApiClient.delete_google_calendar(self.apps_cal_id)
  end
      
end
