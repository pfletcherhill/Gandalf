class LocationsController < ApplicationController
  respond_to :json

  def search
    respond_with Location.name_search(
      Location.sanitize(params[:query])).collect(&:name)
  end
end
