# Controller 
class MainController < ApplicationController
  
  before_action CASClient::Frameworks::Rails::Filter, :only => ["login"]
  before_action :require_login, :only => ["root"]
  
  def welcome
  end

  def login
    redirect_to "/"
  end

  def root
    @me = current_user
  end
  
  def logout
    CASClient::Frameworks::Rails::Filter.logout(self)
  end
  
  def search
    results = Hash.new
    if params[:query]
      results["organizations"] = Organization.search(params[:query])
      results["categories"] = Category.search(params[:query])
      results["events"] = Event.search(params[:query])
    else
      results["organizations"] = Organization.all
      results["categories"] = Category.all
      results["events"] = Event.all
    end
    render json: results
  end
  
end
