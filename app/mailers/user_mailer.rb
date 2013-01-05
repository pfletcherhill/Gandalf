class UserMailer < ActionMailer::Base
  # default :from => "pidgeon@yalego.es"
  default :from => "faiaz.a.khan@gmail.com"
  def daily_bulletin(user)
    mail(
      :to => "#{user.name} <#{user.email}>",
      :subject => "Your Daily Bulletin from Yale Go!"
    )
  end
end
