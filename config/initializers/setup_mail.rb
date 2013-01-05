ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  # :domain               => "gmail.com",
  :user_name            => "faiaz.a.khan", # ENV['GMAIL'],
  :password             => "qRuP0448", # ENV['GMAIL_PASS'],
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = "yalego.es"
# ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?