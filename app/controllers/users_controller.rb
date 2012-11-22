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
  
end
