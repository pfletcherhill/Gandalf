module GroupSpecHelper
  # Fabricates a group. Also sets stub api calls for group creation
  # callbacks and ensures that those callbacks are called.
  # IMPORTANT:
  #   - Calendar summary sets to group_name.
  #   - Creates ACL with 'reader' permission.
  # param {string=} name An optional name for the group.
  # param {string=} skip A comma-separated list of stubs to skip.
  #  Options are 'group', 'cal', 'acl'
  # return {Group} The created group.
  def make_group(name, skip="")
    group_name = name || make_random_hash
    skips = skip.split ","
    group_stub = stub_request(:post, API_GROUP_REGEX("create")).to_return({
      status: 200,
      headers: {'Content-Type' => 'application/json'},
      # body has to be JSON string.
      body: {
        kind: "admin#directory#group",
        id: make_random_hash,
        email: "yalego.#{make_slug(group_name)}@elilists.yale.edu",
        name: "#{group_name}"
        # Also can send adminCreated, description, aliases, nonEditableAliases.
      }.to_json
    }) unless skips.include? "group"
    cal_id = make_random_hash # Need it again for the ACL.
    cal_stub = stub_request(:post, API_CAL_REGEX("create")).to_return({
      status: 200,
      headers: {'Content-Type' => 'application/json'},
      # Has to be JSON string.
      body: {
        kind: "calendar#calendar",
        id: cal_id,
        summary: "#{group_name}"
        # Also can send description, location, timeZone.
      }.to_json
    }) unless skips.include? "cal"
    acl_stub = stub_request(:post, API_ACL_REGEX("create", cal_id)).to_return({
      status: 200,
      headers: {'Content-Type' => 'application/json'},
      # Has to be JSON string.
      body: {
        kind: "calendar#calendarListEntry",
        id: make_random_hash,
        summary: "#{group_name}",
        accessRole: "reader"
        # Also can send description, location, timeZone, summaryOverride,
        #   colors, hidden, selected, primary, defaultReminders.
      }.to_json
    }) unless skips.include? "acl"
    group = Fabricate(:group, name: group_name)
    assert_requested group_stub unless skips.include? "group"
    assert_requested cal_stub unless skips.include? "cal"
    assert_requested acl_stub unless skips.include? "acl"

    return group
  end
end
