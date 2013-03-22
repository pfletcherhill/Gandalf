class UsersController < ApplicationController
  respond_to :json
  before_filter :require_login

  # Email Methods

  def daily_email
    UserMailer.daily_bulletin(current_user).deliver
    redirect_to "/"
  end

  def me
    respond_with current_user
  end

  def facebook
    me = current_user
    me.fb_id = params[:fb_id] if params[:fb_id]
    me.fb_access_token = params[:fb_access_token] if params[:fb_access_token]
    me.nickname ||= params[:nickname]
    if me.save!
      render json: me
    else
      render json: me, status: :unprocessable_entity
    end
  end

  def events
    user = User.find(params[:id])
    events = user.events(params[:start_at], params[:end_at])
    respond_with events
  end

  def organizations
    respond_with User.find(params[:id]).organizations
  end

  def subscriptions
    user = User.find(params[:id])
    subscriptions = user.subscriptions.includes(:subscribeable)
    # Doing this is incredibly inefficient..but apparently no fix :-/
    render json: subscriptions.to_json(:include => :subscribeable)
  end

  def subscribed_organizations
    respond_with User.find(params[:id]).subscribed_organizations
  end

  def subscribed_categories
    respond_with User.find(params[:id]).subscribed_categories
  end

  def follow_organization
    user = User.find(params[:id])
    organization = Organization.find(params[:organization_id])
    user.subscribed_organizations << organization
    respond_with organization
  end

  def unfollow_organization
    organization = Organization.find(params[:organization_id])
    subscription = Subscription.where(
      :subscribeable_type => "Organization", 
      :subscribeable_id => organization.id, 
      :user_id => params[:id]
    ).first
    subscription.destroy
    respond_with organization
  end

  def follow_category
    user = User.find(params[:id])
    category = Category.find(params[:category_id])
    user.subscribed_categories << category
    respond_with category
  end

  def unfollow_category
    category = Category.find(params[:category_id])
    subscription = Subscription.where(
      :subscribeable_type => "Category", 
      :subscribeable_id => category.id, 
      :user_id => params[:id]
    ).first
    subscription.destroy
    respond_with category
  end

  def bulletin_preference
    user = User.find(params[:id])
    val = params[:value] 
    if val == "daily" or val == "weekly" or val == "never"
      user.bulletin_preference = val
      if user.save
        respond_with user
        return
      end
    end
    respond_with user, status: :unprocessable_entity
  end

  def bulletin
    User.send_daily_bulletin
    User.send_weekly_bulletin
    render json: {}
  end

end
