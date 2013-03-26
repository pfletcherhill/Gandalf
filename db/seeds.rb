# Admins

netids = %w(fak23 prf8 alb64)

netids.each do |id|
  User.create_from_directory id
end

colors = {
  red: "255,66,51",
  blue: "107,189,246",
  purple: "164, 57, 214",
  green:"103, 206, 147",
  yellow: "236, 243, 66",
}

colleges = [
  "Berkeley",
  "Branford",
  "Calhoun",
  "Davenport",
  "Jonathan",
  "Edwards",
  "Morse",
  "Pierson",
  "Ezra",
  "Saybrook",
  "Stiles",
  "Silliman",
  "Timothy",
  "Dwight",
  "Trumbull"
]

# Populating with real data...

# Email selection regex: \w+(\.[\w-]+)+@yale.edu

# Student government

ycc = Organization.create(name: "Yale College Council", color: colors[:blue])
fcc = Organization.create(name: "Freshman College Council", color: colors[:blue])
scc = Organization.create(name: "Sophomore College Council", color: colors[:blue])
jcc = Organization.create(name: "Junior College Council", color: colors[:blue])


o = Organization.create(name: "Berkeley College Council", color: colors[:blue])  
o.admins << User.create_from_directory("halley.kaye-kauderer@yale.edu", "email", true)
o = Organization.create(name: "Branford College Council", color: colors[:blue])
o.admins << User.create_from_directory("joyce.li@yale.edu", "email", true)
o = Organization.create(name: "Calhoun College Council", color: colors[:blue])  
o.admins << User.create_from_directory("whitney.schumacher@yale.edu", "email", true)
o = Organization.create(name: "Davenport College Council", color: colors[:blue])  
o.admins << User.create_from_directory("amanda.shadiack@yale.edu", "email", true)
o.admins << User.create_from_directory("hannah.fornero@yale.edu", "email", true)
o = Organization.create(name: "Jonathan Edwards College Council", color: colors[:blue])  
o.admins << User.create_from_directory("christopher.chow@yale.edu", "email", true)
o = Organization.create(name: "Morse College Council", color: colors[:blue])  
o.admins << User.create_from_directory("lucia.duan@yale.edu", "email", true)
o = Organization.create(name: "Pierson College Council", color: colors[:blue])  
# o.admins << User.create_from_directory("alexander.hayden@yale.edu", "email", true)
o = Organization.create(name: "Saybrook College Council", color: colors[:blue])  
o.admins << User.create_from_directory("stuart.teal@yale.edu", "email", true)
o = Organization.create(name: "Ezra Stiles College Council", color: colors[:blue])  
o.admins << User.create_from_directory("alec.arana@yale.edu", "email", true)
o = Organization.create(name: "Silliman College Council", color: colors[:blue])  
o.admins << User.create_from_directory("nicole.desantis@yale.edu", "email", true)
o.admins << User.create_from_directory("alexander.shapiro@yale.edu", "email", true)
o = Organization.create(name: "Timothy Dwight College Council", color: colors[:blue])  
o.admins << User.create_from_directory("samuel.telzak@yale.edu", "email", true)
o = Organization.create(name: "Trumbull College Council", color: colors[:blue])

ycc_board = [
  "john.gonzalez@yale.edu",
  "daniel.avraham@yale.edu",
  "andrea.villena@yale.edu",
  "joseph.yagoda@yale.edu",
  "bryan.epps@yale.edu",
  "aly.moore@yale.edu"
]

# Club sports

o = Organization.create(name: "Club Quidditch", color: colors[:red])
o.admins << User.create_from_directory("erin.burke@yale.edu", "email", true)
o = Organization.create(name: "Club Muay Thai", color: colors[:red])
o.admins << User.create_from_directory("christopher.tokita@yale.edu", "email", true)
o = Organization.create(name: "Club Indoor Climbing", color: colors[:red])
o.admins << User.create_from_directory("andrew.calder@yale.edu", "email", true)
o = Organization.create(name: "Club Snowboarding", color: colors[:red])
o.admins << User.create_from_directory("molly.emerson@yale.edu", "email", true)
o = Organization.create(name: "Club Triathlon", color: colors[:red])
o.admins << User.create_from_directory("christopher.carey@yale.edu", "email", true)
o = Organization.create(name: "Club Golf", color: colors[:red])
o.admins << User.create_from_directory("william.fowkes@yale.edu", "email", true)
o = Organization.create(name: "Club Ultimate Frisbee Women's", color: colors[:red])
o.admins << User.create_from_directory("shirlee.wohl@yale.edu", "email", true)
o = Organization.create(name: "Club Figure Skating", color: colors[:red])
o.admins << User.create_from_directory("austin.haynesworth@yale.edu", "email", true)
o = Organization.create(name: "Club Wrestling", color: colors[:red])
o.admins << User.create_from_directory("michael.l.robinson@yale.edu", "email", true)
o = Organization.create(name: "Club Men's Water Polo", color: colors[:red])
o.admins << User.create_from_directory("keilor.gilbert@yale.edu", "email", true)
o = Organization.create(name: "Club Women's Water Polo", color: colors[:red])
o.admins << User.create_from_directory("courtney.halgren@yale.edu", "email", true)
o = Organization.create(name: "Club Men's Volleyball", color: colors[:red])
o.admins << User.create_from_directory("eric.moy@yale.edu", "email", true)
o = Organization.create(name: "Club Women's Volleyball", color: colors[:red])
o.admins << User.create_from_directory("katheryn.piper@yale.edu", "email", true)
o = Organization.create(name: "Club Men's Tennis", color: colors[:red])
o.admins << User.create_from_directory("henry.casserley@yale.edu", "email", true)
o = Organization.create(name: "Club Women's Tennis", color: colors[:red])
o.admins << User.create_from_directory("rebecca.zhu@yale.edu", "email", true)
o = Organization.create(name: "Club Tae Kwan Do", color: colors[:red])
o.admins << User.create_from_directory("larry.huynh@yale.edu", "email", true)
o = Organization.create(name: "Club Table Tennis", color: colors[:red])
o.admins << User.create_from_directory("yatfung.cheng@yale.edu", "email", true)
o = Organization.create(name: "Club Men's Swimming", color: colors[:red])
o.admins << User.create_from_directory("jack.shu@yale.edu", "email", true)
o = Organization.create(name: "Club Squash", color: colors[:red])
o.admins << User.create_from_directory("anne.keating@yale.edu", "email", true)
o = Organization.create(name: "Club Women's Soccer", color: colors[:red])
o.admins << User.create_from_directory("ariel.kirshenbaum@yale.edu", "email", true)
o = Organization.create(name: "Club Men's Soccer", color: colors[:red])
o.admins << User.create_from_directory("joseph.rosenberg@yale.edu", "email", true)
o = Organization.create(name: "Club Nordic Skiing", color: colors[:red])
o.admins << User.create_from_directory("stephanie.wagner@yale.edu", "email", true)
o = Organization.create(name: "Club Alpine Skiing", color: colors[:red])
o.admins << User.create_from_directory("sinead.obrien@yale.edu", "email", true)
o = Organization.create(name: "Club Skeet and Trap", color: colors[:red])
o.admins << User.create_from_directory("molly.emerson@yale.edu", "email", true)
o = Organization.create(name: "Club Women's Rugby", color: colors[:red])
o.admins << User.create_from_directory("amanda.l.hall@yale.edu", "email", true)
o = Organization.create(name: "Club Men's Rugby", color: colors[:red])
o.admins << User.create_from_directory("nicholas.lombardo@yale.edu", "email", true)
o = Organization.create(name: "Club Road Running", color: colors[:red])
o.admins << User.create_from_directory("emily.ullmann@yale.edu", "email", true)
o = Organization.create(name: "Club Powerlifting", color: colors[:red])
o.admins << User.create_from_directory("max.andersen@yale.edu", "email", true)
o = Organization.create(name: "Club Platform Tennis", color: colors[:red])
o.admins << User.create_from_directory("john.j.sullivan@yale.edu", "email", true)
o = Organization.create(name: "Club Pistol and Rifle", color: colors[:red])
o.admins << User.create_from_directory("cecilia.sanchez@yale.edu", "email", true)
o = Organization.create(name: "Club Men's Lacrosse", color: colors[:red])
o.admins << User.create_from_directory("arthur.sonnenfeld@yale.edu", "email", true)
o = Organization.create(name: "Club Women's Lacrosse", color: colors[:red])
o.admins << User.create_from_directory("gracia.vargas@yale.edu", "email", true)
o = Organization.create(name: "Club Ice Hockey", color: colors[:red])
o.admins << User.create_from_directory("brian.ruwe@yale.edu", "email", true)
o = Organization.create(name: "Club Fishing", color: colors[:red])
o.admins << User.create_from_directory("richard.riddle@yale.edu", "email", true)
o = Organization.create(name: "Club Field Hockey", color: colors[:red])
o.admins << User.create_from_directory("megan.sullivan@yale.edu", "email", true)
o = Organization.create(name: "Club Equestrian", color: colors[:red])
o.admins << User.create_from_directory("kaitlin.mclean@yale.edu", "email", true)
o = Organization.create(name: "Club Cycling", color: colors[:red])
o.admins << User.create_from_directory("ian.forsyth@yale.edu", "email", true)
o = Organization.create(name: "Club Cricket", color: colors[:red])
o.admins << User.create_from_directory("heshika.deegahawathura@yale.edu", "email", true)
o = Organization.create(name: "Club Men's Basketball", color: colors[:red])
# o.admins << User.create_from_directory("edward.ewell@yale.edu", "email", true)
o = Organization.create(name: "Club Women's Basketball", color: colors[:red])
o.admins << User.create_from_directory("nicole.ivey@yale.edu", "email", true)
o = Organization.create(name: "Club Men's Baseball", color: colors[:red])
o.admins << User.create_from_directory("steven.morales@yale.edu", "email", true)
o = Organization.create(name: "Club Badminton", color: colors[:red])
o.admins << User.create_from_directory("eric.chen@yale.edu", "email", true)

o = Organization.create(name: "Club Karate", color: colors[:red])
o = Organization.create(name: "Club Ultimate Frisbee Men's", color: colors[:red])
o = Organization.create(name: "Club Polo", color: colors[:red])





o1 = Organization.create(:name => "TEDxYale", :color => "255,66,51")
o2 = Organization.create(:name => "HackYale", :color => "107,189,246")
o3 = Organization.create(:name => "Yale University", :color => "27,112,224")
o4 = Organization.create(:name => "STC", :color => "103, 206, 147")
o5 = Organization.create(:name => "Pierson College IMs", :color => "236, 243, 66")
o6 = Organization.create(:name => "The Duke's Men of Yale")
print "#{Organization.count} organizations created...\n"

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

unknown = Location.create(
  name: "Unknown",
  address: "Yale University, New Haven, CT"
)

art_gallery = Location.create(
  :name => "Yale University Art Gallery Auditorium", 
  :address => "1111 Chapel Street, New Haven, CT 06511"
)
LocationAlias.create( value: "YUAG", location: art_gallery )

ceid = Location.create(
  :name => "Center for Engineering Innovation and Design", 
  :address => "15 Prospect St., New Haven, CT 06511"
)
LocationAlias.create( value: "CEID", location: ceid )
LocationAlias.create( value: "C.E.I.D.", location: ceid )

shubert = Location.create(
  :name => "Shubert Theater", 
  :address => "247 College Street, New Haven, CT 06511"
)
pwg = Location.create(
  name: "Payne Whitney Gym",
  address: "70 Tower Parkway, New Haven, CT 06520",
)
LocationAlias.create(value: "PWG", location: pwg)

wlh = Location.create(
  name: "William L Harkness Hall",
  address: "100 Wall Street, New Haven, CT"
)
LocationAlias.create(value: "WLH", location: wlh)

print "#{Location.count} locations created...\n"

e = Event.new(
  :name => "TEDxYale City 2.0",
  :organization_id => o1.id,
  :start_at => Time.now + 20.hour,
  :end_at => Time.now + 26.hour,
  :location => shubert,
  :room_number => "Main Theater",
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
  :room_number => "114",
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

rafi.organizations << Organization.all

adam.organizations << o4

print "access controls created...\n"
paul.subscribed_organizations << o1
paul.subscribed_organizations << o2
paul.subscribed_organizations << o3
paul.subscribed_organizations << o4
paul.subscribed_organizations << o5
paul.subscribed_organizations << o6

rafi.subscribed_organizations << Organization.all

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


