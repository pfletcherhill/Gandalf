class EventsController < ApplicationController
  
  before_filter :require_login

  def require_login
    unless logged_in?
      redirect_to '/welcome' # halts request cycle
    end
  end
 
  def logged_in?
    !!current_user
  end

  def index
    @events = Event.all
  end

end
