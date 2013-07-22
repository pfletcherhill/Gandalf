# JSON API for events.

class EventsController < ApplicationController
  
  before_filter :require_login
  respond_to :json

  # Repond with all events, ordered by updated time.
  def index
    respond_with Event
      .order("updated_at DESC")
      .includes(:categories, :organization, :location)
  end

  def show
    respond_with Event.find(params[:id])
  end

  # Creates an event. Location defaults to "Unknown".
  def create
    name = params[:event][:location] || "Unknown"
    location = Location.name_search(Location.sanitize(name)).first
    location = Location.create!(:name => name, :gmaps => true) unless location

    @event = Event.new(params[:event].except(:location, :category_ids))
    @event.location = location
    # I know we do this for some particular reason but I forgot why...
    @event.start_at = params[:event][:start_at]
    @event.end_at = params[:event][:end_at]
    @event.set_categories params[:event][:category_ids]
    if @event.save
      render json: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def update
    location_name = params[:event][:location]
    location = Location.name_search(Location.sanitize(location_name)).first
    location = Location.create(
      :name => location_name, :gmaps => true) unless location
    # Set the location id for update_attributes
    params[:event][:location_id] = location.id

    event = Event.find(params[:event][:id])
    event.set_categories params[:event][:category_ids]
    respond_with event.update_attributes(
      params[:event].except(:location, :category_ids, :organization_slug))
  end

  def destroy
    respond_with Event.find(params[:id]).destroy
  end

  # Search the full text of an event, including its organizations,
  # categories and location. If the query is null, responds with
  # all events, sorted by updated time.
  def search
    if params[:query]
      respond_with Event
        .fulltext_search(params[:query])
        .includes(:categories, :organization, :location)
    else
      Event
        .order("updated_at DESC")
        .includes(:categories, :organization, :location)
    end
  end

end
