Fabricator(:event) do
  name { sequence(:name) {|i| "TEDxYale #{i}"} }
  organization_id { Fabricate(:organization).id }
  start_at { Time.now() }
  end_at { Time.now() + 1.hour }
end
