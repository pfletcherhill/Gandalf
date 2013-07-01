class Category < ActiveRecord::Base

  include Gandalf::GoogleApiClient
  include Gandalf::Utilities
  
  # Associations
  has_many :subscriptions, as: :subscribeable
  has_many :subscribers, through: :subscriptions, source: :user
  has_many :groups, as: :groupable
  has_many :events, through: :groups
  
  # Callbacks
  before_validation :set_slug
  after_create :generate_groups

  # Validations
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false 
  validates_uniqueness_of :slug, :case_sensitive => false
  
  # Search
  include PgSearch
  
  multisearchable against: [
    :name,
    :description
  ]
  
  pg_search_scope :fulltext_search,
    :against => {
      :name => "A", 
      :description => "B"
    }, 
    :using => {
      :tsearch => {
        :prefix => true,
        anyword: true
      }
    }

  def set_slug
    self.slug = make_slug(name)
  end

  def generate_groups
    self.groups << Group.create(name: "category.#{self.slug}")
  end
  
  def group
    self.groups.first
  end
    
  #Events, can have start and end

  def complete_events
    self.events
      .includes(:location, :organization, :categories)
      .order("start_at")
  end
  
  def events_count
    self.events.count
  end

  def events_with_period(*times)
    start_at = times[0]
    end_at = times[1]
    start_at = Date.strptime(start_at, '%m-%d-%Y')
    end_at = Date.strptime(end_at, '%m-%d-%Y')
    query = "start_at < :end AND end_at > :start"
    events = self.complete_events
      .where(query,{ :start => start_at, :end => end_at })
    events
  end

  # Class methods
  
  def Category.find_or_generate_by_name(name)
    cat = Category.where(:name => name).first
    unless cat
      cat = Category.new(:name => name, :description => name)
      cat.slug = make_slug(name)
      cat.save
    end
    cat
  end
  
  def Category.import_categories(file)
    require 'csv'
    csv = CSV.open(file, :encoding => 'windows-1251:utf-8')
    begin
      csv.each do |row|
        Category.find_or_generate_by_name(row[0])
      end
    rescue
    end
  end

end
