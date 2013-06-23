Fabricator(:event) do
  name "My event"
  organization_id { Organization.first.id }
  start_at { Time.now }
  end_at { Time.now + 1.hour }
end
