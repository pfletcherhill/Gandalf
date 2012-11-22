class OrganizationsController < ApplicationController
  
  def all
    organizations = Organization.all
    render json: organizations
  end
  
end
