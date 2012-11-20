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
  end
  
  def all
    events = Event.all
    render json: events.as_json
  end

end
