module SpecUtilities
  API_GROUPS_URL_REGEX = /www.googleapis.com\/admin\/directory\/v1\/groups/
  API_CAL_URL_REGEX = /www.googleapis.com\/calendar\/v3\/calendars/

  # Fabricates a group. Also sets stub api calls for group creation
  # callbacks and ensures that those callbacks are called.
  # param {string=} name An optional name for the group.
  # return {Group} The created group.
  def make_group(name)
    group_name = name || Gandalf::Utilities.make_random_hash
    group_stub = stub_request(:post, API_GROUPS_URL_REGEX).to_return({
      status: 200,
      headers: {'Content-Type' => 'application/json'},
      # body has to be JSON string.
      body: {
        kind: "admin#directory#group",
        id: "#{Gandalf::Utilities.make_random_hash}",
        email: "yalego.#{make_slug(group_name)}@elilists.yale.edu",
        name: "#{group_name}"
        # Also can send adminCreated, description, aliases, nonEditableAliases.
      }.to_json
    })
    cal_stub = stub_request(:post, API_CAL_URL_REGEX).to_return({
      status: 200,
      headers: {'Content-Type' => 'application/json'},
      # Has to be JSON string.
      body: {
        kind: "calendar#calendar",
        id: "#{Gandalf::Utilities.make_random_hash}",
        summary: "#{group_name}",
        # Also can send description, location, timeZone.
      }.to_json
    })
    group = Fabricate(:group, name: group_name)
    assert_requested group_stub
    assert_requested cal_stub
    return group
  end

  # Fabricates an event. Also sets stub api calls for event creation
  # callbacks and ensures that those callbacks are called.
  # param {string=} name An optional name for the event.
  # return {Event} The created event.
  def make_event


  end
end
