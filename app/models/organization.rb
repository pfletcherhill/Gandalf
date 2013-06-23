class Organization < ActiveRecord::Base
  require 'gappsprovisioning/provisioningapi'

  # Associations
  has_many :events
  has_many :access_controls
  has_many :admins, :through => :access_controls, :source => :user
  has_many :subscriptions, :as => :subscribeable
  has_many :subscribers, :through => :subscriptions, :source => :user

  # Validations
  validates_uniqueness_of :name, :case_sensitive => false
  validates_uniqueness_of :slug, :case_sensitive => false

  # Callbacks
  before_create :make_slug

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

  # Google Apps integration
  include GAppsProvisioning

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

  # Gapps methods

  # def Organization.get_gapp
  #   return @@myapp
  # end

  # # Gets an 'EliList'. 
  # def Organization.get_gapp_group(id)
  #   # Get the groups each time...perhaps make more efficient later
  #   @@myapp.retrieve_all_groups.each do |g|
  #     return g if g.group_id == id
  #   end
  #   return nil
  # end

  # @@myapp = ProvisioningApi.new(ENV['GAPPS_EMAIL'], ENV['GAPPS_PASS'])
  
  private

  def make_slug
    self.slug ||= Subscription.make_slug self.name
  end

end
