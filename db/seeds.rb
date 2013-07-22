# # Seed all categories if in production
# print("Importing categories...")
# unless Rails.env.production?
#   Category.import_categories("lib/data/categories.csv")
# end
# print("DONE\n")

# Seed all student organizations
# Or just admins if in production
# print("Importing student organizations...")
# unless Rails.env.production?
#   Organization.import_student_organizations("lib/data/student_groups.csv")
# else
  users = { prf8: "TEDxYale", fak23: "HackYale" }
  users.each do |id, org|
    u = User.create_from_directory id
    o = Organization.find_or_create_by_name org
    u.add_authorization_to o if u
  end
# end
print("DONE\n")

# # Promote admins
# print("Promoting admins...")
# netids = %w(prf8 fak23)
# netids.each do |id|
#   u = User.find_by_netid(id)
#   u.admin = true
#   u.save
# end
# print("DONE\n")

locations = [
  "Yale University",
  "Harvard University"
]

print("Creating locations...")
locations.each do |l|
  Location.create!(:name => l, :gmaps => true)
end
printf("DONE\n")

print("Creating events...")
Event.create_upcoming_events(10, Organization.first)
printf("DONE\n")

# # Scrape this month's events
# print("Scraping this month's events...")
# date = DateTime.now.strftime("%Y%m%d")
# url = "http://calendar.yale.edu/cal/opa/month/#{date}/All/?showDetails=yes"
# Event.scrape_yale_events(url)
# printf("DONE\n")
