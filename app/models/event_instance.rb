class EventInstance < ActiveRecord::Base
  
  include Gandalf::GoogleApiClient
  include Gandalf::Utilities
  
  # Associations
  belongs_to :event
  belongs_to :group
  
  # Validations
  validates_presence_of :event_id, :group_id
  
end
