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
  
  def show
    event = Event.find(params[:id])
    render json: event.as_json
  end
  
  def create
    name = params[:event][:location]
    location = Location.where(:name => name).first
    location = Location.create(:name => name, :gmaps => true) unless location
    params[:event][:location] = nil
    @event = Event.new(params[:event])
    @event.location = location
    # For some reason, these weren't working...
    @event[:start_at] = params[:event][:start_at]
    @event.end_at = params[:event][:end_at]
    puts "PARAMS:"
    puts location
    p params[:event][:start_at]
    p params[:event][:end_at]
    p @event
    if @event.save
      render json: @event.as_json
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end
  
  def search
    query = params[:query]
    events = Event.fulltext_search(query)
    render json: events.as_json
  end

end
