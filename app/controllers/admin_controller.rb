class AdminController < ApplicationController
  
  before_filter :require_admin
  
  def index
    redirect_to "/admin/events"
  end
  
  def users
    @users = User.all
  end
  
  def events
    @events = Event.all
  end
  
  def organizations
    @organizations = Organization.all
  end
  
  def categories
    @categories = Category.all
  end
  
  def import
    csv = params[:csv]
    redirect_to "/admin/users"
  end
  
end
