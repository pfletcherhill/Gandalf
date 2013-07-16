module EventSpecHelper
  API_EVENT_REGEX = /www.googleapis.com\/calendar\/v3\/calendars\/[\d\w]+\/events/
  # Fabricates an event. Also sets stub api calls for event creation
  # callbacks and ensures that those callbacks are called.
  # param {string=} name An optional name for the event.
  # return {Event} The created event.
  def make_event


  end

  # 
  def stub_event_request(method, cal_id, event_id)
    event_stub = stub_request(method, API_GROUPS_URL_REGEX).to_return({
      status: 200,
      headers: {'Content-Type' => 'application/json'},
      # body has to be JSON string.
      body: {
        kind: "calendar#event",
        id: "#{event_id || Gandalf::Utilities.make_random_hash}",
        email: "yalego.#{make_slug(group_name)}@elilists.yale.edu",
        name: "#{group_name}"
        # Also can send adminCreated, description, aliases, nonEditableAliases.
      }.to_json
    })
  end
end
