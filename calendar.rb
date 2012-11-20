# Initialize the client & Google+ API
require 'google/api-client'
client = Google::APIClient.new
plus = client.discovered_api('plus')

# Initialize OAuth 2.0 client    
client.authorization.client_id = 'yalegandalf'
client.authorization.client_secret = 'AIzaSyDxC7qcloU94l5dvOEdAoQTZ7AijIX65gw'
client.authorization.redirect_uri = ''

client.authorization.scope = 'https://www.googleapis.com/auth/plus.me'

# Request authorization
redirect_uri = client.authorization.authorization_uri

# Wait for authorization code then exchange for token
client.authorization.code = '....'
client.authorization.fetch_access_token!

# Make an API call
result = client.execute(
  :api_method => plus.activities.list,
  :parameters => {'collection' => 'public', 'userId' => 'me'}
)

puts result.data