class UsersController < ApplicationController
  respond_to :json
  before_filter :require_login

  # Email Methods

  def daily_email
    UserMailer.daily_bulletin(current_user).deliver
    redirect_to "/"
  end

  def me
    me = current_user
    p me
    render json: me
  end

  def update
    me = current_user
    if me.id != params[:user][:id]
      render json: {}, status: :unprocessable_entity
    end
    me.fb_id = params[:user][:fb_id] if params[:user][:fb_id]
    me.fb_access_token = params[:user][:fb_access_token] if params[:user][:fb_access_token]
    me.nickname ||= params[:user][:nickname]
    if me.save!
      render json: me
    else
      render json: me, status: :unprocessable_entity
    end
  end

  def events
    user = current_user
    events = user.events(params[:start_at], params[:end_at])
    respond_with events
  end

  def organizations
    respond_with current_user.organizations
  end

  def subscriptions
    user = current_user
    subscriptions = user.subscriptions.includes(:subscribeable)
    # Doing this is incredibly inefficient..but apparently no fix :-/
    render json: subscriptions.to_json(:include => :subscribeable)
  end

  def subscribed_organizations
    respond_with current_user.subscribed_organizations
  end

  def subscribed_categories
    respond_with current_user.subscribed_categories
  end

  def follow_organization
    user = current_user
    organization = Organization.find(params[:organization_id])
    user.subscribed_organizations << organization
    respond_with organization
  end

  def unfollow_organization
    organization = Organization.find(params[:organization_id])
    subscription = Subscription.where(
      :subscribeable_type => "Organization", 
      :subscribeable_id => organization.id, 
      :user_id => current_user.id
    ).first
    subscription.destroy
    respond_with organization
  end

  def follow_category
    user = current_user
    category = Category.find(params[:category_id])
    user.subscribed_categories << category
    render json: category
  end

  def unfollow_category
    category = Category.find(params[:category_id])
    subscription = Subscription.where(
      :subscribeable_type => "Category", 
      :subscribeable_id => category.id, 
      :user_id => current_user.id
    ).first
    subscription.destroy
    render json: category
  end

  def bulletin_preference
    user = current_user
    val = params[:value] 
    if val == "daily" or val == "weekly" or val == "never"
      user.bulletin_preference = val
      if user.save
        render json: user
        return
      end
    end
    render json: user, status: :unprocessable_entity
  end

  def bulletin
    User.send_daily_bulletin
    User.send_weekly_bulletin
    render json: {}
  end

end
