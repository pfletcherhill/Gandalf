Fabricator(:group) do
  name { sequence(:name) {|i| "TEDxYale Followers #{i}"} }
  groupable_id { Fabricate(:organization).id }
  groupable_type "Organization"
end