Fabricator(:group) do
  name { sequence(:name) {|i| "TEDxYale Followers #{i}"} }
  type "Team"
end
