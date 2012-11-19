class EventsController < ApplicationController
  before_filter CASClient::Frameworks::Rails::Filter

  def index
    @user = User.find_by_netid(session[:cas_user])
    if not @user
      begin 
        @user = User.create_user_from_directory session[:cas_user]
      rescue
        flash[:error] = "Couldn't get you from the directory"
      end
    end
    @events = Event.all
  end

end
