class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  helper_method :require_login
  
  private
  
  def current_user
    @current_user = User.find_by_netid(session[:cas_user])
    unless @current_user
      @current_user = User.create_from_directory(session[:cas_user])
      unless @current_user
        flash[:error] = "Couldn't get you from the directory"
        session[:cas_user] = nil
      end
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
        redirect_to '/welcome' #halts request cycle
      end
    else
      redirect_to '/welcome' #halts request cycle
    end
  end
  
end
