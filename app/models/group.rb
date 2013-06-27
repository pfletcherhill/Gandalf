class Group < ActiveRecord::Base
  
  include Gandalf::Utilities
  
  # Associations
  has_and_belongs_to_many :events
  belongs_to :groupable, polymorphic: true
  
  # Callbacks
  before_create :set_slug
  
  # Methods
  def set_slug
    slug = make_slug(name)
  end
    
end
