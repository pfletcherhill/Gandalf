credentials = YAML.load_file("#{Rails.root}/config/credentials.yml")
sendgrid = credentials['sendgrid']
pass = credentials['sendgrid_password']
ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  :user_name      => sendgrid,
  :password       => pass,
  :domain         => 'heroku.com'
}
ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.default_url_options[:host] = "yalego.es"
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?