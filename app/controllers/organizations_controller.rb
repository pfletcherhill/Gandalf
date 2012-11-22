class OrganizationsController < ApplicationController
  
  def all
    organizations = Organization.all
    render json: organizations
  end
  
  def show
    organization = Organization.find(params[:id])
    render json: organization
  end
  
end
