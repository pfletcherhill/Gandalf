class OrganizationsController < ApplicationController
  
  def index
    organizations = Organization.all
    render json: organizations
  end
  
  def show
    organization = Organization.find(params[:id])
    render json: organization
  end
  
  def update
    @organization = Organization.find(params[:id])

    respond_to do |format|
      if @organization.update_attributes(params[:organization])
        format.html
        format.json { render json: @organization }
      else
        format.html
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end
  
end
