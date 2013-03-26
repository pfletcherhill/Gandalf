class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  helper_method :require_login
  
  private
  
  def current_user
    @current_user = User.includes(:organizations).find_by_netid(session[:cas_user])
    if not @current_user
      @current_user = User.create_from_directory(session[:cas_user])
      flash[:error] = "Couldn't get you from the directory" if not @current_user
    end
    if not @current_user
      session[:cas_user] = nil
    end
    @current_user
  end

  def require_login
    unless !!session[:cas_user]
      redirect_to '/welcome' # halts request cycle
    end
  end
  
  def require_admin
    if session[:cas_user]
      unless User.find_by_netid(session[:cas_user]).admin == true
        redirect_to '/' #halts request cycle
      end
    else
      redirect_to '/' #halts request cycle
    end
  end
  
end
