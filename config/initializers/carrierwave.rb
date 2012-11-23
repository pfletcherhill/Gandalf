#config/initializers/carrierwave.rb
credentials = YAML.load_file("#{Rails.root}/config/credentials.yml")

ENV['aws_access_key_id'] = credentials['aws_access_key_id']
ENV['aws_secret_access_key'] = credentials['aws_secret_access_key']

CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => ENV['aws_access_key_id'],
    :aws_secret_access_key  => ENV['aws_secret_access_key']
  }
  config.fog_directory  = 'Gandalf'
  #config.fog_host       = 'http://gandalf.s3-website-us-east-1.amazonaws.com/'
  config.fog_public     = false
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
end