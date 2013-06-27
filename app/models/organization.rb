class Organization < ActiveRecord::Base

  include Gandalf::Utilities
  include Gandalf::GoogleApiClient
  
  # Associations
  has_many :subscriptions, :as => :subscribeable
  has_many :subscribers, :through => :subscriptions, :source => :user
  has_many :groups, as: :groupable
  has_many :events, through: :groups
  
  # Access Controls  
  has_many :admins,
           through: :subscriptions,
           source: :user,
           conditions: ['subscriptions.access_type = ?', ACCESS_STATES[:ADMIN]]
  has_many :members,
           through: :subscriptions,
           source: :user,
           conditions: ['subscriptions.access_type = ?', ACCESS_STATES[:MEMBER]]
  has_many :followers,
           through: :subscriptions,
           source: :user,
           conditions: ['subscriptions.access_type = ?', ACCESS_STATES[:FOLLOWER]]

  # Validations
  validates_uniqueness_of :name, :case_sensitive => false
  validates_uniqueness_of :slug, :case_sensitive => false

  # Callbacks
  before_create :set_slug

  # pg_search
  include PgSearch
  multisearchable :against => [:name, :bio]
  pg_search_scope :fulltext_search, 
    :against => {
      :name => "A", 
      :bio => "B"
    }, 
    :using => {
      :tsearch => {
        :prefix => true,
        :dictionary => "english",
        :any_word => true
      }
    }

  #Image Uploader
  mount_uploader :image, ImageUploader

  def set_slug
    slug = make_slug(name)
  end
  
  def complete_events
    self.events
      .includes(:location, :organization, :categories)
      .order("start_at")
  end
  
  def popular_categories
    self.categories.first(10)
  end
  
  def events_count
    self.events.count
  end
  
  #Events, can have start and end
  def events_with_period(*times)
    start_at = times[0]
    end_at = times[1]
    start_at = Date.strptime(start_at, '%m-%d-%Y')
    end_at = Date.strptime(end_at, '%m-%d-%Y')
    query = "start_at < :end AND end_at > :start"
    @events = self.complete_events
      .where(query, { :start => start_at, :end => end_at })
    @events
  end

  # Categories, sorted by most frequent
  def categories
    events = self.events.includes(:categories)
    categories = events.map{|event| event.categories}.flatten
    categories.uniq.sort_by{ |c| categories.grep(c).size }.reverse
  end
  
  # Class methods
  
  def Organization.import_student_organizations(file)
    require 'csv'
    csv = CSV.open(file, :encoding => 'windows-1251:utf-8')
    begin
      csv.each do |row|
        organization = Organization.find_or_create_by_name(row[1])
        user = User.where(:email => row[0]).first
        user = User.create_from_directory(row[0], "email") unless user
        user.add_authorization_to organization if user
      end
    rescue
    end
  end
  
end
