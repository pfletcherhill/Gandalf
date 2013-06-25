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

# Unless in production, load environment constants from credentials.yml.
# Our credentials.yml file is not pushed to production, and the constants
# our defined in heroku configs
unless Rails.env.production?
  credentials = YAML.load_file("#{Rails.root}/config/credentials.yml")
  ENV['CAS_NETID']                        = credentials['netid']
  ENV['CAS_PASS']                         = credentials['password']
  ENV['GMAIL']                            = credentials['gmail']
  ENV['GMAPS_KEY']                        = credentials['gmaps_key']
  ENV['FACEBOOK_APP_ID']                  = credentials['facebook_app_id']
  ENV['FACEBOOK_APP_SECRET']              = credentials['facebook_app_secret']
  ENV['SERVICE_ACCOUNT_EMAIL']            = credentials['service_account_email']
  ENV['SERVICE_ACCOUNT_PKCS12_FILE_PATH'] = Rails.root.to_s + credentials['service_account_pkcs12_file_path']
  ENV['KEY_SECRET']                       = credentials['key_secret']
  ENV['ACCOUNT_EMAIL']                    = credentials['account_email']
end
