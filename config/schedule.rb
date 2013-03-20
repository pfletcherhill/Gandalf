set :output, "#{path}/log/cron.log"

time_to_send = "6:00 am"

every 1.days, at: time_to_send do 
  runner "User.send_daily_bulletin"
end

every :sunday, at: time_to_send do
  runner "User.send_weekly_bulletin"
end