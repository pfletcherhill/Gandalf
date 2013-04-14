require 'gappsprovisioning/provisioningapi'
include GAppsProvisioning

myapps = ProvisioningApi.new(ENV['GAPPS_EMAIL'], ENV['GAPPS_PASS'])
all = myapps.retreive_all_groups
p all
# g = myapps.create_group("rafi-test", ["Rafi Test", "Awesome", "member"])