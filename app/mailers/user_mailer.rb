class UserMailer < ActionMailer::Base
  default :from => "The Yale Go Pigeon <pigeon@yalego.es>"
  def bulletin(user, time="daily")
    logger.info "Sending #{time} bulletin to #{user.email}..."
    @user = user
    @events = @user.upcoming_events
    @time = time
    mail(
      :to => "#{user.name} <#{user.email}>",
      :subject => "Your #{@time.camelize} Bulletin from Yale Go!"
    )
  end
  
  def subscriber_email(email, body, subject)
    @body = body
    mail(
      :to => email,
      :subject => subject
    )
  end
end
