class EventsController < ApplicationController
  respond_to :json

  def index
    respond_with Event.includes(:categories, :organization, :location)
  end

  def show
    respond_with Event.find(params[:id])
  end

  def create
    name = params[:event][:location]
    location = Location.name_search(Location.sanitize(name)).first
    location = Location.create!(:name => name, :gmaps => true) unless location

    params[:event][:location] = nil
    @event = Event.new(params[:event])
    @event.location = location
    # I know we do this for some particular reason but I forgot why...
    @event.start_at = params[:event][:start_at]
    @event.end_at = params[:event][:end_at]
    @event.set_categories params[:event][:category_ids]
    if @event.save
      respond_with @event
    else
      respond_with @event.errors, status: :unprocessable_entity
    end
  end

  def update
    location_name = params[:event][:location]
    location = Location.name_search(Location.sanitize(location_name)).first
    location = Location.create(:name => location_name, :gmaps => true) unless location
    # Set the location id for update_attributes
    params[:event][:location_id] = location.id

    event = Event.find(params[:event][:id])
    event.set_categories params[:event][:category_ids]
    respond_with event.update_attributes(params[:event].except(:location, :category_ids))
  end

  def destroy
    respond_with Event.find(params[:id]).destroy
  end

  def search
    respond_with Event.fulltext_search(params[:query])
  end

end
