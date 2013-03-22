class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  helper_method :require_login
  
  private
  
  def current_user
    if session[:cas_user]
      @current_user = User.includes(:organizations).find_by_netid(session[:cas_user])
      if not @current_user
        begin 
          @current_user = User.create_from_directory(session[:cas_user])
        rescue
          flash[:error] = "Couldn't get you from the directory"
        end
      end
      @current_user
    else
      nil
    end
  end

  def require_login
    unless !!session[:cas_user]
      redirect_to '/welcome' # halts request cycle
    end
  end
  
end
