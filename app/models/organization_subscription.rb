class OrganizationSubscription < ActiveRecord::Base
  
  #Associtations
  belongs_to :user
  belongs_to :organization
  
end
