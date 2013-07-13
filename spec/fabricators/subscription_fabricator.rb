Fabricator(:subscription) do
  access_type { ACCESS_STATES[:FOLLOWER] }
  user_id { Fabricate(:user).id }
  group_id { Fabricate(:group).id }
end