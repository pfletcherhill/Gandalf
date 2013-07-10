Fabricator(:category) do
  name { sequence(:name) {|i| "TED Talks #{i}"} }
end