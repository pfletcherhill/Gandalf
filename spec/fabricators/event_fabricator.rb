Fabricator(:event) do
  name { sequence(:name) {|i| "TEDxYale #{i}"} }
  organization_id { Fabricate(:organization).id }
end
