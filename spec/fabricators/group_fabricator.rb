Fabricator(:group) do
  name { sequence(:name) {|i| "TEDxYale Followers #{i}"} }
  organization_id { Fabricate(:organization).id }
  type "Team"
end