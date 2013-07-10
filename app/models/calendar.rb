class Calendar < Group
  
  # Associations
  belongs_to :organization
  
  # Validations
  validates_presence_of :organization_id
  
end
