class CategorySubscription < ActiveRecord::Base
  
  #Associtations
  belongs_to :user
  belongs_to :category
  
end
