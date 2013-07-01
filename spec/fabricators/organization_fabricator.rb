Fabricator(:organization) do
  name { sequence(:name) {|i| "TEDxYale #{i}"} }
end