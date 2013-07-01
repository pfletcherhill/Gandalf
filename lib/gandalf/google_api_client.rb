module Gandalf::GoogleApiClient
  
  require 'google/api_client'
  
  def self.build_client(scope)

    # Initialize client, load PKCS12 key, and authorize it. 
    key = Google::APIClient::PKCS12.load_key(ENV['SERVICE_ACCOUNT_PKCS12_FILE_PATH'], ENV['KEY_SECRET'])
    asserter = Google::APIClient::JWTAsserter.new(ENV['SERVICE_ACCOUNT_EMAIL'], scope, key)
    client = Google::APIClient.new(application_name: 'TEDxYaleGo')
    client.authorization = asserter.authorize(ENV['ACCOUNT_EMAIL'])
    client
    
  end
  
end
