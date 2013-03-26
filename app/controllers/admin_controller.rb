class AdminController < ApplicationController
  
  before_filter :require_admin
  
  def index
    redirect_to "/admin/events"
  end
  
  def users
    @users = User.all
  end
  
  def events
    @events = Event.all
  end
  
  def organizations
    @organizations = Organization.all
  end
  
  def categories
    @categories = Category.all
  end
  
  def import
    csv = params[:csv]
    redirect_to "/admin/users"
  end
  
  def scrape
    date = DateTime.now.strftime("%Y%m%d")
    if params[:url]
      url = params[:url]
    elsif params[:period] == "week"
      url = "http://calendar.yale.edu/cal/opa/week/#{date}/All/?showDetails=yes"
    elsif params[:period] == "month"
      url = "http://calendar.yale.edu/cal/opa/month/#{date}/All/?showDetails=yes"
    end
    if url
      puts("it has url")
      Delayed::Job.enqueue ScrapeYaleEvents.new(url), :run_at => 10.seconds.from_now - 4.hours
    end
    redirect_to "/admin/events"
  end
  
end
