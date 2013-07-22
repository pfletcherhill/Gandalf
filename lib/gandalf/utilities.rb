module Gandalf::Utilities
  
  # Permissions for group access level.
  # People who have WRITE access to a group are called its admins,
  # those with READONLY are members, those with RESTRICTED are followers.
  # This is different from a group's admin_team, members_team and followers_team,
  #   which are subgroups that are created for each group to h
  # Below 'constituents' means admins, members and followers of a group.
  ACCESS_STATES = { 
    RESTRICTED: 0,  # Can see a group's events, but not their constituents.
    READONLY: 1,    # Can see a group's events and their constituents
                    #   (and the access_state of each constituent).
    WRITE: 2        # Can edit a group's events and their constituents.
  }

  def make_slug(name)
    name.downcase.strip       # Downcase and removes surrounding whitespace
      .gsub(/ /, "-")         # Replace internal spaces with hyphens
      .gsub(/[^\w\d\-_]/, "") # Remove all non-alphanumeric characters expect - and _

      # .gsub(/&/, "and")       # Replace & character with "and"...dubious
  end

  def make_random_hash
    SecureRandom.hex(8)
  end
  
  def self.make_cas_browser
    browser = Mechanize.new
    browser.get("https://secure.its.yale.edu/cas/login")
    form = browser.page.forms.first
    form.username = ENV['CAS_NETID']
    form.password = ENV['CAS_PASS']
    form.submit
    browser
  end
  
end
