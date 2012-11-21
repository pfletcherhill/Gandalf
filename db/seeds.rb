netids = %w(prf8 fak23 rcl6)

netids.each do |id|
  User.create_from_directory id
end

o1 = Organization.create(:name => "TEDxYale")
o2 = Organization.create(:name => "HackYale")
print "organizations created...\n"
c1 = Category.create(:name => "Tech")
c2 = Category.create(:name => "TED Talks")
c3 = Category.create(:name => "Awesomeness")
print "categories created...\n"
e = Event.new(:name => "TEDxYale City 2.0", :organization_id => o1.id, :start_at => Time.now + 24.hour, :end_at => Time.now + 26.hour, :location => "Yale University Art Gallery Auditorium")
e.categories << c1
e.categories << c2
e.categories << c3
e.save
e = Event.new(:name => "TEDxYale Solve for y", :organization_id => o1.id, :start_at => Time.now + 10.day, :end_at => Time.now + 11.day, :location => "Shubert Theater")
e.categories << c2
e.categories << c3
e.save
e = Event.new(:name => "Hackathon", :organization_id => o2.id, :start_at => Time.now + 2.day, :end_at => Time.now + 3.day, :location => "Center for Engineering, Innovation and Design")
e.categories << c1
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


