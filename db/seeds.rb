netids = %w(prf8 fak23 alb64)

netids.each do |id|
  User.create_from_directory id
end

o1 = Organization.create(:name => "TEDxYale", :color => "255,66,51")
o2 = Organization.create(:name => "HackYale", :color => "107,189,246")
o3 = Organization.create(:name => "Yale University", :color => "27,112,224")
o4 = Organization.create(:name => "STC", :color => "103, 206, 147")
o5 = Organization.create(:name => "Pierson College IMs", :color => "236, 243, 66")
o6 = Organization.create(:name => "The Duke's Men of Yale")
print "organizations created...\n"

categories = [
  # Performances
  "A Capella",
  "Concert",
  "Dance",
  "Film",
  "Poetry",
  "Theater",

  # Academics
  "Arts & Architecture",
  "Humanities & Social Sciences",
  "Science & Medicine",
  "Technology",

  # Activities
  "Career",
  "Classes & Workshops",
  "Community",
  "Conference",
  "Family Friendly",
  "Free Food",
  "Intramurals",
  "Spiritual & Worship",
  "Sports",
  "Talks & Readings",
  "Tours: museum",
  "Tours: campus",

  # Colleges
  "Berkeley College",
  "Branford College",
  "Calhoun College",
  "Davenport College",
  "Ezra Stiles College",
  "Jonathan Edwards College",
  "Morse College",
  "Pierson College",
  "Saybrook College",
  "Silliman College",
  "Timothy Dwight College",
  "Trumbull College"
]
categories.each do |c|
  Category.create!(
    name: c,
    description: c,
    slug: Subscription.make_slug(c)
  )
end

acapella = Category.find 1
concert = Category.find 2
arts = Category.find 7
tech = Category.find 10
pierson = Category.where(name: "Pierson College").first
free_food = Category.where(name: "Free Food").first
im = Category.where(name: "Intramurals").first

print "#{Category.count} categories created...\n"

art_gallery = Location.create(
  :name => "Yale University Art Gallery Auditorium", 
  :address => "1111 Chapel Street, New Haven, CT 06511"
)
ceid = Location.create(
  :name => "Center for Engineering, Innovation and Design", 
  :address => "15 Prospect St., New Haven, CT 06511"
)
shubert = Location.create(
  :name => "Shubert Theater", 
  :address => "247 College Street, New Haven, CT 06511"
)
pwg = Location.create(
  name: "Payne Whitney Gym",
  address: "70 Tower Parkway, New Haven, CT 06520",
)
wlh = Location.create(
  name: "William L. Harkness Hall",
  address: "100 Wall Street, New Haven, CT"
)

print "#{Location.count} locations created...\n"

e = Event.new(
  :name => "TEDxYale City 2.0",
  :organization_id => o1.id,
  :start_at => Time.now + 20.hour,
  :end_at => Time.now + 26.hour,
  :location => shubert,
  :description => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed at elit semper tortor varius tincidunt. In aliquet malesuada luctus. Etiam curs"
)
e.categories << arts
e.categories << tech
e.categories << free_food
e.save

e = Event.new(
  :name => "Hackathon",
  :organization_id => o2.id,
  :start_at => Time.now + 22.hour,
  :end_at => Time.now + 28.hour,
  :location => ceid,
  :description => "A super long Hackathon!"
)
e.categories << tech
e.categories << free_food
e.save

e = Event.new(
  :name => "More HackYale",
  :organization_id => o2.id,
  :start_at => Time.now + 29.hour,
  :end_at => Time.now + 30.hour,
  :location => wlh,
  :description => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed at elit semper tortor varius tincidunt. In aliquet malesuada luctus. Etiam curs"
)
e.categories << tech
e.categories << free_food
e.save

e = Event.new(
  :name => "Art.sy Visit",
  :organization_id => o2.id,
  :start_at => Time.now + 25.hour,
  :end_at => Time.now + 27.hour,
  :location => wlh,
  :description => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed at elit semper tortor varius tincidunt. In aliquet malesuada luctus. Etiam curs"
)
e.categories << tech
e.categories << free_food
e.save

e = Event.new(
  :name => "Tech Talk",
  :organization_id => o2.id, 
  :start_at => Time.now + 27.hour, 
  :end_at => Time.now + 30.hour, 
  :location => ceid,
  :description => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed at elit semper tortor varius tincidunt. In aliquet malesuada luctus. Etiam curs"
)
e.categories << tech
e.categories << free_food
e.save

e = Event.new(
  :name => "HackYale",
  :organization_id => o2.id,
  :start_at => Time.now + 2.day,
  :end_at => Time.now + 50.hour,
  :location => ceid,
  :description => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed at elit semper tortor varius tincidunt. In aliquet malesuada luctus. Etiam curs"
)
e.categories << tech
e.categories << free_food
e.save

e = Event.new(
  :name => "TEDxYale Solve for y",
  :organization_id => o1.id,
  :start_at => Time.now + 1.day + 10.hour,
  :end_at => Time.now + 11.day + 11.hour,
  :location => shubert,
  :description => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed at elit semper tortor varius tincidunt. In aliquet malesuada luctus. Etiam curs",
)
e.categories << arts
e.categories << tech
e.categories << free_food
e.categories << Category.where(name: "Community").first
e.categories << Category.where(name: "Conference").first
e.categories << Category.where(name: "Family Friendly").first
e.save

e = Event.new(
  :name => "STC group meeting",
  :organization_id => o4.id,
  :start_at => Time.now + 1.day + 10.hour,
  :end_at => Time.now + 1.day + 14.hour,
  :location => ceid,
  :description => "We're getting together to do cool stuff!"
)

e.save

e = Event.new(
  :name => "IM Soccer",
  :organization_id => o5.id,
  :start_at => Time.now + 2.day + 10.hour,
  :end_at => Time.now + 2.day + 13.hour,
  :location => pwg,
  :description => "Come out we need people!"
)
e.categories << im
e.categories << pierson
e.save

e = Event.new(
  :name => "Strawberry Jam",
  :organization_id => o6.id,
  :start_at => Time.now + 5.day + 10.hour,
  :end_at => Time.now + 5.day + 15.hour,
  :location => wlh,
  :description => "The most delicious jam ever!"
)
e.categories << acapella
e.categories << concert
e.categories << Category.where(name: "Family Friendly").first

e.save

print "#{Event.count} events created...\n"

paul = User.find_by_netid('prf8')
rafi = User.find_by_netid('fak23')
adam = User.find_by_netid('alb64')

paul.organizations << o1
paul.organizations << o2

rafi.organizations << o1
rafi.organizations << o2
rafi.organizations << o3
rafi.organizations << o4
rafi.organizations << o5
rafi.organizations << o6

adam.organizations << o4

print "access controls created...\n"
paul.subscribed_organizations << o1
paul.subscribed_organizations << o2
paul.subscribed_organizations << o3
paul.subscribed_organizations << o4
paul.subscribed_organizations << o5
paul.subscribed_organizations << o6

rafi.subscribed_organizations << o1
rafi.subscribed_organizations << o2
rafi.subscribed_organizations << o3
rafi.subscribed_organizations << o4
rafi.subscribed_organizations << o5
rafi.subscribed_organizations << o6

adam.subscribed_organizations << o1
adam.subscribed_organizations << o2
adam.subscribed_organizations << o3
adam.subscribed_organizations << o4

paul.subscribed_categories << tech
paul.subscribed_categories << free_food
paul.subscribed_categories << pierson

rafi.subscribed_categories << tech
rafi.subscribed_categories << free_food
rafi.subscribed_categories << pierson
rafi.subscribed_categories << Category.where(name: "Family Friendly").first

adam.subscribed_categories << tech
adam.subscribed_categories << free_food
adam.subscribed_categories << pierson
rafi.bulletin_preference = "weekly"

print "subscriptions created...\n"


