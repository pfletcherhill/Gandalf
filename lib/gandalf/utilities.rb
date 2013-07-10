module Gandalf::Utilities
  
  def make_slug(name)
    name.downcase.gsub(/ /, "-").gsub(/&/, "and").gsub(/[,\.\)\(:']/, "")
  end
  
  ACCESS_STATES = {
    FOLLOWER: 0,
    MEMBER: 1,
    ADMIN: 2
  }
  
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