class OrganizationsController < ApplicationController
  
  def index
    @organizations = Organization.all
    render json: @organizations
  end
  
  def show
    @organization = Organization.find(params[:id])
    render json: @organization
  end
  
  def edit
    @organization = Organization.find(params[:id])
    if current_user.has_authorization_to(@organization)
      render json: @organization
    else
      render json: "User does not have access", status: 403
    end
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
  
  def add_image
    @organization = Organization.find(params[:id])
    @organization.image = params[:image]
    @organization.save
    render json: @organization
  end
  
  def events
    @organization = Organization.find(params[:id])
    @events = @organization.events
    render json: @events.as_json
  end
  
end
