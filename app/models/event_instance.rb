class EventInstance < ActiveRecord::Base
  
  include Gandalf::GoogleApiClient
  include Gandalf::Utilities
  
  # Associations
  belongs_to :event
  belongs_to :group
  
  # Validations
  validates_presence_of :event_id, :group_id
  
  # Callbacks
  after_create :create_google_event
  after_update :update_google_event
  after_destroy :destroy_google_event
  
  def google_calendar_id
    self.group.apps_cal_id
  end
  
  def google_organizer
    g = self.group
    { "email" => g.apps_email, "displayName" => g.name }
  end
  
  def create_google_event
    result = Gandalf::GoogleApiClient.insert_google_event(self.google_calendar_id,
      self.make_google_hash)
    self.apps_id = result.data.id if result.data
    self.save
  end

  def update_google_event
    result = Gandalf::GoogleApiClient.update_google_event(self.google_calendar_id,
      self.apps_id, self.make_google_hash)
    # self.save if result.status == 200 # Do we care if this succeeds?
  end

  def destroy_google_event
    result = Gandalf::GoogleApiClient.delete_google_event(self.google_calendar_id,
      self.apps_id)
  end

  # Make hash for all the parameters needed for google create and update.
  def make_google_hash
    e = self.event # keep a reference to avoid repeated querying.
    return {
      "start" => e.google_start,
      "end" => e.google_end,
      "description" => e.description,
      "summary" => e.name,
      "location" => e.google_location,
      "organizer" => self.google_organizer
    }
  end
end
