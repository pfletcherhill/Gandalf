# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Gandalf::Application.initialize!

require 'casclient'
require 'casclient/frameworks/rails/filter'
CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => "https://secure.its.yale.edu/cas/",
  :username_session_key => :cas_user
)

# For this line to work, create #{Rails.root}/config/cas_credentials.yml
# and format it like so:
# 
# netid: <YOUR NETID>
# password: <YOUR CAS PASSWORD>
# 
# The file is already added to .gitignore, so don't worry about it being pushed  

unless Rails.env.production?
  credentials = YAML.load_file("#{Rails.root}/config/credentials.yml")
  ENV['CAS_NETID'] = credentials['netid']
  ENV['CAS_PASS'] = credentials['password']
  ENV['GMAIL'] = credentials['gmail']
  ENV['GMAIL_PASS'] = credentials['gmail_password']
  ENV['SENDGRID'] = credentials['sendgrid']
  ENV['SENDGRID_PASS'] = credentials['sendgrid_password']
end

