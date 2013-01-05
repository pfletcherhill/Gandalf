credentials = YAML.load_file("#{Rails.root}/config/credentials.yml")
gmail = credentials['gmail']
pass = credentials['gmail_password']
ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :user_name            => gmail,
  :password             => pass,
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = "yalego.es"
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?