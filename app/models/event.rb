class Event < ActiveRecord::Base
  
  #Associations
  belongs_to :organization
  has_and_belongs_to_many :categories
  
end
