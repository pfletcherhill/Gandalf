credentials = YAML.load_file("#{Rails.root}/config/credentials.yml")
ENV["SENDGRID_USERNAME"] = credentials['sendgrid']
ENV["SENDGRID_PASSWORD"] = credentials['sendgrid_password']

ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  :user_name      => ENV["SENDGRID_USERNAME"],
  :password       => ENV["SENDGRID_PASSWORD"],
  :domain         => 'heroku.com'
}
ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.default_url_options[:host] = "yalego.es"
if Rails.env.development? or Rails.env.production? or Rails.env.test?
  ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor)
end