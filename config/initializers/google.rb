# Setup
# SERVICE_ACCOUNT_EMAIL = '526818427591-28qrg15dtqut0bs8hgbebp492td27ntr@developer.gserviceaccount.com'
# SERVICE_ACCOUNT_PKCS12_FILE_PATH = '../private_key.p12'
# 
# # Build client method
# # Takes user email and authenticates client appropriately
# def build_client(user_email)
#     key = Google::APIClient::PKCS12.load_key(SERVICE_ACCOUNT_PKCS12_FILE_PATH, 'notasecret')
#     asserter = Google::APIClient::JWTAsserter.new(SERVICE_ACCOUNT_EMAIL,
#         'https://www.googleapis.com/auth/admin.directory.group', key)
#     client = Google::APIClient.new
#     client.authorization = asserter.authorize(user_email)
#     client
# end
# 
# # Define directory object
# client = build_client("curator@tedxyale.com")
# directory = client.discovered_api("admin", "directory_v1")

# # Execute GET groups
# # Get group object for yalego.subscribers.tedxyale@tedxyale.com
# result = client.execute(:api_method => directory.groups.get, :parameters => {
#   "groupKey" => "yalego.subscribers.tedxyale@tedxyale.com"
# })
# 
# # Puts result in json
# puts "subscribers group: #{result.data.to_json}"
# 
# # Execute GET groups for member
# result = client.execute(:api_method => directory.groups.list, :parameters => {
#   "userKey" => "rafi@tedxyale.com"
# })
# 
# # Puts result in json
# puts "rafi's groups: #{result.data.to_json}"