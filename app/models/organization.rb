class Organization < ActiveRecord::Base

  include Gandalf::Utilities
  include Gandalf::GoogleApiClient
  
  # Associations
  has_many :subscriptions, :as => :subscribeable, dependent: :destroy
  has_many :subscribers, :through => :subscriptions, :source => :user
  has_many :groups, as: :groupable, dependent: :destroy
  has_many :events
  
  # Access Controls  
  has_many :admins, -> { where 'subscriptions.access_type = ?', ACCESS_STATES[:ADMIN]},
           through: :subscriptions,
           source: :user
  has_many :members, -> { where 'subscriptions.access_type = ?', ACCESS_STATES[:MEMBER]},
           through: :subscriptions,
           source: :user
  has_many :followers, -> { where 'subscriptions.access_type = ?', ACCESS_STATES[:FOLLOWER]},
           through: :subscriptions,
           source: :user

  # Validations
  validates_presence_of :name, :slug
  validates_uniqueness_of :name, :case_sensitive => false
  validates_uniqueness_of :slug, :case_sensitive => false

  # Callbacks
  before_validation :set_slug
  after_create :setup_groups

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

  # Image Uploader
  mount_uploader :image, ImageUploader

  # Callbacks
  
  def set_slug
    self.slug = make_slug(name)
  end
  
  def setup_groups
    ["Admins", "Members", "Followers"].each do |group_type|
      Group.create(
        name: "#{name} #{group_type}",
        groupable_id: id,
        groupable_type: "Organization"
      )
    end
  end
  
  # Methods
  
  def admins_group
    groups.where(slug: "#{slug}-admins").first
  end
  
  def followers_group
    groups.where(slug: "#{slug}-followers").first
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
