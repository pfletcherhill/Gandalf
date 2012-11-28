netids = %w(prf8 fak23 rcl6)

netids.each do |id|
  User.create_from_directory id
end

o1 = Organization.create(:name => "TEDxYale", :color => "251,51,51")
o2 = Organization.create(:name => "HackYale", :color => "107,189,246")
print "organizations created...\n"
c1 = Category.create(:name => "Tech")
c2 = Category.create(:name => "TED Talks")
c3 = Category.create(:name => "Awesomeness")
print "categories created...\n"
e = Event.new(
  :name => "TEDxYale City 2.0",
  :organization_id => o1.id,
  :start_at => Time.now + 20.hour,
  :end_at => Time.now + 26.hour,
  :location => "Yale University Art Gallery Auditorium",
  :description => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed at elit semper tortor varius tincidunt. In aliquet malesuada luctus. Etiam cursus dui tellus, ut accumsan turpis. Sed ut tortor ut eros sagittis facilisis. Nulla magna tortor, semper et tristique dictum, laoreet ac libero. Ut a magna urna, vel hendrerit nisl.",
  :address => "1111 Chapel Street, New Haven, CT 06511"
)

e.categories << c1
e.categories << c2
e.categories << c3
e.save
e = Event.new(
  :name => "Hackathon",
  :organization_id => o2.id,
  :start_at => Time.now + 22.hour,
  :end_at => Time.now + 28.hour,
  :location => "Center for Engineering, Innovation and Design",
  :description => "A super long Hackathon!",
  :address => "15 Prospect St., New Haven, CT 06511"
)
e.categories << c1
e.categories << c3
e.save
e = Event.new(
  :name => "More HackYale",
  :organization_id => o2.id,
  :start_at => Time.now + 29.hour,
  :end_at => Time.now + 30.hour,
  :location => "Center for Engineering, Innovation and Design",
  :description => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed at elit semper tortor varius tincidunt. In aliquet malesuada luctus. Etiam cursus dui tellus, ut accumsan turpis. Sed ut tortor ut eros sagittis facilisis. Nulla magna tortor, semper et tristique dictum, laoreet ac libero. Ut a magna urna, vel hendrerit nisl.",
  :address => "15 Prospect St., New Haven, CT 06511"
)
e.categories << c1
e.categories << c3
e.save
e = Event.new(
  :name => "Art.sy Visit",
  :organization_id => o2.id,
  :start_at => Time.now + 25.hour,
  :end_at => Time.now + 27.hour,
  :location => "Center for Engineering, Innovation and Design",
  :description => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed at elit semper tortor varius tincidunt. In aliquet malesuada luctus. Etiam cursus dui tellus, ut accumsan turpis. Sed ut tortor ut eros sagittis facilisis. Nulla magna tortor, semper et tristique dictum, laoreet ac libero. Ut a magna urna, vel hendrerit nisl.",
  :address => "15 Prospect St., New Haven, CT 06511"
)
e.categories << c1
e.categories << c3
e.save
e = Event.new(
  :name => "Tech Talk",
  :organization_id => o2.id, 
  :start_at => Time.now + 27.hour, 
  :end_at => Time.now + 30.hour, 
  :location => "Center for Engineering, Innovation and Design",
  :description => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed at elit semper tortor varius tincidunt. In aliquet malesuada luctus. Etiam cursus dui tellus, ut accumsan turpis. Sed ut tortor ut eros sagittis facilisis. Nulla magna tortor, semper et tristique dictum, laoreet ac libero. Ut a magna urna, vel hendrerit nisl.",
  :address => "15 Prospect St., New Haven, CT 06511"
)
e.categories << c1
e.categories << c3
e.save
e = Event.new(
  :name => "HackYale",
  :organization_id => o2.id,
  :start_at => Time.now + 2.day,
  :end_at => Time.now + 50.hour,
  :location => "Center for Engineering, Innovation and Design",
  :description => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed at elit semper tortor varius tincidunt. In aliquet malesuada luctus. Etiam cursus dui tellus, ut accumsan turpis. Sed ut tortor ut eros sagittis facilisis. Nulla magna tortor, semper et tristique dictum, laoreet ac libero. Ut a magna urna, vel hendrerit nisl.",
  :address => "15 Prospect St., New Haven, CT 06511"
)
e.categories << c1
e.categories << c3
e.save
e = Event.new(
  :name => "TEDxYale Solve for y",
  :organization_id => o1.id,
  :start_at => Time.now + 10.day,
  :end_at => Time.now + 11.day,
  :location => "Shubert Theater",
  :description => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed at elit semper tortor varius tincidunt. In aliquet malesuada luctus. Etiam cursus dui tellus, ut accumsan turpis. Sed ut tortor ut eros sagittis facilisis. Nulla magna tortor, semper et tristique dictum, laoreet ac libero. Ut a magna urna, vel hendrerit nisl.",
  :address => "247 College Street, New Haven, CT 06511"
)
e.categories << c2
e.categories << c3
e.save

print "events created...\n"
u1 = User.find_by_netid('prf8')
u2 = User.find_by_netid('fak23')
u3 = User.find_by_netid('rcl6')
u1.organizations << o1
u2.organizations << o2
print "access controls created...\n"
u1.subscribed_organizations << o1
u1.subscribed_organizations << o2
u2.subscribed_organizations << o1
u2.subscribed_organizations << o2
u3.subscribed_organizations << o1
u3.subscribed_organizations << o2
u1.subscribed_categories << c1
u1.subscribed_categories << c2
u2.subscribed_categories << c2
u2.subscribed_categories << c3
u3.subscribed_categories << c1
u3.subscribed_categories << c2
u3.subscribed_categories << c3
print "subscriptions created...\n"


