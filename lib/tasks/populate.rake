namespace :db do
  desc "Populate database with test data"
  task :populate => :environment do
    user = User.first
    if user
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
      User.first.organizations << o1
      print "access controls created...\n"
      User.first.subscribed_organizations << o1
      User.first.subscribed_organizations << o2
      User.first.subscribed_categories << c1
      User.first.subscribed_categories << c2
    else
      print "ERROR: a user must exist before populating database..."
    end
  end
end