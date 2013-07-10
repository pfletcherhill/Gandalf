Fabricator(:subscription) do
  access_type { ACCESS_STATES[:FOLLOWER] }
  user_id { Fabricate(:user).id }
  group_id { Fabricate(:group).id }
  subscribeable_id { Fabricate(:organization).id }
  subscribeable_type "Organization"
end