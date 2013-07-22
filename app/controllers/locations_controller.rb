class LocationsController < ApplicationController
  
  before_filter :require_login
  respond_to :json

  def search
    respond_with Location.name_search(
      Location.sanitize(params[:query])).collect(&:name)
  end
end
