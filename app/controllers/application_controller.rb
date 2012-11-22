class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  
  private
  
  def current_user
    if session[:cas_user]
      @current_user = User.find_by_netid(session[:cas_user])
      if not @current_user
        begin 
          @current_user = User.create_from_directory(session[:cas_user])
        rescue
          flash[:error] = "Couldn't get you from the directory"
        end
      end
      @current_user
    end
  end
  
end
