module SpecUtilities
  API_GROUPS_BASE = "www.googleapis.com/admin/directory/v1/groups"
  API_CAL_BASE = "www.googleapis.com/calendar/v3/calendars"
  # The following methods are macros for generating URL regexes for querying
  # different APIs. They all take a method, and an ID which is required for
  # all methods but create.
  # For security, all Regexs are terminated with a $ for end of line.
  # param {symbol|string} method The API method to call
  # param {string=} id The item ID. Not required for the :create action.
  # return {RegExp} The RegExp that matches the Google API query for that method
  #   to that service.
  def API_GROUP_REGEX(method, id=nil)
    if method == :create or method == "create"
      return Regexp.new(API_GROUPS_BASE + "$")
    else
      raise ArgumentError.new('No group ID given') unless id
      return Regexp.new(API_GROUPS_BASE + "/" + id + "$")
    end
  end

  def API_MEMBER_REGEX(method, group_id, member_id=nil)
    if method == "create" or method == :create
      # ACLs are created by querying the calendar.
      return Regexp.new(API_GROUPS_BASE + "/" + group_id + "/members$")
    else
      raise ArgumentError.new('No member ID given') unless member_id
      return Regexp.new(API_GROUPS_BASE + "/" + group_id + "/members/" + member_id + "$")
    end
  end

  def API_CAL_REGEX(method, id=nil)
    if method == "create" or method == :create
      return Regexp.new(API_CAL_BASE + "$")
    else
      raise ArgumentError.new('No calendar ID given') unless id
      return Regexp.new(API_CAL_BASE + "/" + id + "$")
    end
  end

  def API_ACL_REGEX(method, cal_id, acl_id=nil)
    if method == "create" or method == :create
      # ACLs are created by querying the calendar.
      return Regexp.new(API_CAL_BASE + "/" + cal_id + "/acl$")
    else
      raise ArgumentError.new('No ACL ID given') unless acl_id
      return Regexp.new(API_CAL_BASE + "/" + cal_id + "/acl/" + acl_id + "$")
    end
  end
end
