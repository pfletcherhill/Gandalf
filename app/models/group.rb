class Group < ActiveRecord::Base
  
  include Gandalf::Utilities
  include Gandalf::GoogleApiClient
  
  # Associations
  has_and_belongs_to_many :events
  belongs_to :groupable, polymorphic: true
  
  # Callbacks
  before_validation :set_slug
  before_create :set_apps_email
  before_create :setup_google_group
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
  
  # Defines scopes for the Google API
  def self.google_scopes
    "https://www.googleapis.com/auth/admin.directory.group"
  end
  
  # setup_google_group creates a google group and sets the model's
  # apps_id and apps_email
  def setup_google_group
    
    result = Group.create_google_group({
      "email" => self.apps_email || self.set_apps_email,
      "name" => self.name,
      "description" => self.description
    })
    
    # If a conflict exists in the database
    if result.status == 409
      result = Group.get_google_group(self.apps_email)
    end
    
    # Set the apps_id and apps_email from the returned object
    self.apps_id = result.data.id
    self.apps_email = result.data.email
    
  end
  
  # destroy_google_group deletes the google group
  def destroy_google_group
    result = Group.delete_google_group(self.apps_id)
  end
  
  # Google API Group Class Methods
  
  # List google groups
  def self.list_google_groups
    
    @client = Gandalf::GoogleApiClient.build_client(Group.google_scopes) unless @client
    
    directory = @client.discovered_api("admin", "directory")
    
    @client.execute({
      api_method: directory.groups.list
    })
  end
  
  # Get google group
  # group_key can be the group's email address, 
  # alias or unique string id
  def self.get_google_group(group_key)
    
    @client = Gandalf::GoogleApiClient.build_client(Group.google_scopes) unless @client
    
    directory = @client.discovered_api("admin", "directory_v1")
    
    @client.execute({
      api_method: directory.groups.get,
      parameters: { "groupKey" => group_key }
    })
  end
  
  # Create a google group using body_object
  def self.create_google_group(body_object)
    
    @client = Gandalf::GoogleApiClient.build_client(Group.google_scopes) unless @client
    
    directory = @client.discovered_api("admin", "directory_v1")
    
    @client.execute({
      api_method: directory.groups.insert,
      body_object: body_object
    })
  end
  
  # Update a google group using the passed in group_object
  def self.update_google_group(group_key, group_object)
    
    @client = Gandalf::GoogleApiClient.build_client(Group.google_scopes) unless @client
    
    directory = @client.discovered_api("admin", "directory_v1")
    
    @client.execute({
      api_method: directory.groups.update,
      parameters: { "groupKey" => group_key },
      body_object: group_object
    })
  end
  
  # Delete a google group
  # group_key can be the group's email address, 
  # alias or unique string id
  def self.delete_google_group(group_key)
    
    @client = Gandalf::GoogleApiClient.build_client(Group.google_scopes) unless @client
    
    directory = @client.discovered_api("admin", "directory_v1")
    
    @client.execute({
      api_method: directory.groups.delete,
      parameters: { "groupKey" => group_key }
    })
  end
    
end
