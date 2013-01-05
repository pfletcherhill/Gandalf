ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :user_name            => "faiaz.a.khan@gmail.com", # ENV['GMAIL'],
  :password             => "qRuP0448", # ENV['GMAIL_PASS'],
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = "yalego.es"
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?