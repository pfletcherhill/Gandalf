module Gandalf::GoogleApiClient
  
  require 'google/api_client'
  
  GOOGLE_SCOPES = "https://www.googleapis.com/auth/admin.directory.group https://www.googleapis.com/auth/calendar"
  
  def self.build_client(scope)

    # Initialize client, load PKCS12 key, and authorize it. 
    key = Google::APIClient::PKCS12.load_key(ENV['SERVICE_ACCOUNT_PKCS12_FILE_PATH'], ENV['KEY_SECRET'])
    asserter = Google::APIClient::JWTAsserter.new(ENV['SERVICE_ACCOUNT_EMAIL'], scope, key)
    client = Google::APIClient.new(application_name: 'TEDxYaleGo')
    client.authorization = asserter.authorize(ENV['ACCOUNT_EMAIL'])
    client
    
  end
  
  # Google API Group Class Methods
  
  # List google groups
  def self.list_google_groups
    
    @client = build_client(GOOGLE_SCOPES) unless @client
    
    directory = @client.discovered_api("admin", "directory")
    
    @client.execute({
      api_method: directory.groups.list
    })
  end
  
  # Get google group
  # group_key can be the group's email address, 
  # alias or unique string id
  def self.get_google_group(group_key)
    
    @client = build_client(GOOGLE_SCOPES) unless @client
    
    directory = @client.discovered_api("admin", "directory_v1")
    
    @client.execute({
      api_method: directory.groups.get,
      parameters: { "groupKey" => group_key }
    })
  end
  
  # Create a google group using body_object
  def self.insert_google_group(body_object)
    
    @client = build_client(GOOGLE_SCOPES) unless @client
    
    directory = @client.discovered_api("admin", "directory_v1")
    
    @client.execute({
      api_method: directory.groups.insert,
      body_object: body_object
    })
  end
  
  # Update a google group using the passed in group_object
  def self.update_google_group(group_key, group_object)
    
    @client = build_client(GOOGLE_SCOPES) unless @client
    
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
    
    @client = build_client(GOOGLE_SCOPES) unless @client
    
    directory = @client.discovered_api("admin", "directory_v1")
    
    @client.execute({
      api_method: directory.groups.delete,
      parameters: { "groupKey" => group_key }
    })
  end
  
  # Google API Calendar Class Methods
  
  # List google calendars
  def self.list_google_calendars
    
    @client = build_client(GOOGLE_SCOPES) unless @client
    
    calendar = @client.discovered_api("calendar", "v3")
    
    @client.execute({
      api_method: calendar.calendar_list.list
    })
  end
  
  def self.get_google_calendar(calendar_id)
    
    @client = build_client(GOOGLE_SCOPES) unless @client
    
    calendar = @client.discovered_api("calendar", "v3")
    
    @client.execute({
      api_method: calendar.calendar_list.get,
      parameters: { "calendarId" => calendar_id }
    })
  end
  
  def self.insert_google_calendar(calendar_object)
    
    @client = build_client(GOOGLE_SCOPES) unless @client
    
    calendar = @client.discovered_api("calendar", "v3")
    
    @client.execute({
      api_method: calendar.calendars.insert,
      body_object: calendar_object
    })
  end
  
  def delete_google_calendar(calendar_id)
    
    @client = build_client(GOOGLE_SCOPES) unless @client
    
    calendar = @client.discovered_api("calendar", "v3")
    
    @client.execute({
      api_method: calendar.calendar_list.delete,
      parameters: { "calendarId" => calendar_id }
    })
  end
  
  # Google API Event Class Methods
  
  def self.insert_google_event(calendar_id, event_object)
    
    @client = build_client(GOOGLE_SCOPES) unless @client
    
    calendar = @client.discovered_api("calendar", "v3")
    
    @client.execute({
      api_method: calendar.events.insert,
      parameters: { "calendarId" => calendar_id },
      body_object: event_object
    })
  end

  def self.get_google_event(calendar_id, event_id)
    
    @client = build_client(GOOGLE_SCOPES) unless @client
    
    calendar = @client.discovered_api("calendar", "v3")
    
    @client.execute({
      api_method: calendar.events.get,
      parameters: {
        "calendarId" => calendar_id,
        "eventId" => event_id
      }
    })
  end
end
