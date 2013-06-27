module Gandalf::Utilities
  
  def make_slug(name)
    name.downcase.gsub(/ /, "-").gsub(/&/, "and").gsub(/[,\.\)\(:']/, "")
  end
  
  ACCESS_STATES = {
    FOLLOWER: 0,
    MEMBER: 1,
    ADMIN: 2
  }
  
end