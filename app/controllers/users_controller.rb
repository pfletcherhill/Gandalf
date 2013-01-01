class UsersController < ApplicationController
  
  before_filter :require_login

  def require_login
    unless logged_in?
      redirect_to '/welcome'
    end
  end
 
  def logged_in?
    !!current_user
  end
  
  def me
    render json: current_user.as_json
  end
  
  def events
    user = User.find(params[:id])
    events = user.events(params[:start_at], params[:end_at])
    render json: events.as_json
  end
  
  def organizations
    user = User.find(params[:id])
    organizations = user.organizations
    render json: organizations
  end
  
  def subscribed_organizations
    user = User.find(params[:id])
    organizations = user.subscribed_organizations
    render json: organizations
  end
  
  def subscribed_categories
    user = User.find(params[:id])
    categories = user.subscribed_categories
    render json: categories
  end
  
  def follow_organization
    user = User.find(params[:id])
    organization = Organization.find(params[:organization_id])
    user.subscribed_organizations << organization
    render json: organization
  end
  
  def unfollow_organization
    organization = Organization.find(params[:organization_id])
    subscription = Subscription.where(:subscribeable_type => "Organization", :subscribeable_id => organization.id, :user_id => params[:id]).first
    subscription.destroy
    render json: organization
  end
  
end
