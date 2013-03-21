class Category < ActiveRecord::Base

  # Associations
  has_and_belongs_to_many :events
  has_many :subscriptions, :as => :subscribeable
  has_many :subscribers, :through => :subscriptions, :source => :user

  # Callbacks
  before_create :make_slug

  #pg_search
  include PgSearch
  multisearchable :against => [:name, :description]
  pg_search_scope :fulltext_search,
    against: [:name, :description],
    using: { tsearch:  {
      prefix: true, 
      dictionary: "english",
      any_word: true
    } }

  #Events, can have start and end

  def complete_events
    self.events
      .includes(:location, :organization, :categories)
      .order("start_at")
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

  private

  def make_slug
    if not self.slug and self.name
      self.slug = Subscription.make_slug self.name
    end
  end

end
