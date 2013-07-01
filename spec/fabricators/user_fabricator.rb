Fabricator(:user) do
  netid { sequence(:netid) {|i| "prf#{i}"} }
  name "Paul Fletcher-Hill"
  email { sequence(:email) {|i| "paul.fletcher-hill+#{i}@yale.edu"} }
  division "Yale College"
end