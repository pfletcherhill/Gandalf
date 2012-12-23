class MainController < ApplicationController
  
  before_filter CASClient::Frameworks::Rails::Filter, :only => ["login"]
  
  def welcome
  end

  def login
    redirect_to "/"
  end
  
  def logout
    CASClient::Frameworks::Rails::Filter.logout(self)
  end
  
  def search_all
  end
  
end
