# Seed all categories
print("Importing categories...")
unless Rails.env.production?
  Category.import_categories("lib/data/categories.csv")
end
print("DONE\n")

# Seed all student organizations
print("Importing student organizations...")
unless Rails.env.production?
  Organization.import_student_organizations("lib/data/student_groups.csv")
end
print("DONE\n")

# Seed this month's events
print("Scraping this month's events...")
date = DateTime.now.strftime("%Y%m%d")
url = "http://calendar.yale.edu/cal/opa/month/#{date}/All/?showDetails=yes"
Event.scrape_yale_events(url)
printf("DONE\n")

# Admins
print("Promoting admins...")
netids = %w(fak23 prf8)
netids.each do |id|
  u = User.where(:netid => id).first
  u.admin = true
  u.save
end
print("DONE\n")
