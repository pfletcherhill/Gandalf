# Admins

netids = %w(fak23 prf8)

netids.each do |id|
  u = User.create_from_directory id
  u.admin = true
  u.save
end

# Student government
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


