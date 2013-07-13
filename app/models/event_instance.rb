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
  
  def google_calendar_id
    self.group.apps_cal_id
  end
  
  def google_organizer
    {
      "email" => self.group.apps_email,
      "displayName" => self.group.name
    }
  end
  
  def create_google_event
    result = Gandalf::GoogleApiClient.insert_google_event(self.google_calendar_id, {
      "start" => self.event.google_start,
      "end" => self.event.google_end,
      "description" => self.event.description,
      "summary" => self.event.name,
      "location" => self.event.google_location,
      "organizer" => self.google_organizer
    })
    
    self.apps_id = result.data.id
    self.save
  end
  
end
