class UsersController < ApplicationController

  before_filter :require_login

  #Email Methods
  def daily_email
    UserMailer.daily_bulletin(current_user).deliver
    redirect_to "/"
  end

  def require_login
    unless logged_in?
      redirect_to '/welcome'
    end
  end

  def logged_in?
    !!current_user
  end

  def me
    render json: current_user
  end

  def events
    user = User.find(params[:id])
    events = user.events(params[:start_at], params[:end_at])
    render json: events
  end

  def organizations
    user = User.find(params[:id])
    organizations = user.organizations
    render json: organizations
  end

  def subscriptions
    user = User.find(params[:id])
    subscriptions = user.subscriptions.includes(:subscribeable)
    # Doing this is incredibly inefficient..but apparently no fix :-/
    render json: subscriptions.to_json(:include => :subscribeable)
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
    subscription = Subscription.where(
      :subscribeable_type => "Organization", 
      :subscribeable_id => organization.id, 
      :user_id => params[:id]
    ).first
    subscription.destroy
    render json: organization
  end

  def follow_category
    user = User.find(params[:id])
    category = Category.find(params[:category_id])
    user.subscribed_categories << category
    render json: category
  end

  def unfollow_category
    category = Category.find(params[:category_id])
    subscription = Subscription.where(
      :subscribeable_type => "Category", 
      :subscribeable_id => category.id, 
      :user_id => params[:id]
    ).first
    subscription.destroy
    render json: category
  end

  def bulletin_preference
    user = User.find(params[:id])
    val = params[:value] 
    if val == "daily" or val == "weekly" or val == "never"
      user.bulletin_preference = val
      user.save
      render json: user
    else
      render json: "bad option", status: :unprocessable_entity
    end
  end

  def bulletin
    User.send_daily_bulletin
    User.send_weekly_bulletin
    render json: {}
  end

end
