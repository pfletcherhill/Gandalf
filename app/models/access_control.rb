class AccessControl < ActiveRecord::Base
  
  # Assocations
  belongs_to :user
  belongs_to :organization
  
end
