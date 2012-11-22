#config/initializers/carrierwave.rb
CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => ENV['aws_access_key_id'],
    :aws_secret_access_key  => ENV['aws_secret_access_key']
  }
  config.fog_directory  = 'Gandalf'
  config.fog_host       = 'http://Gandalf.s3.amazonaws.com/'
  config.fog_public     = false
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
end