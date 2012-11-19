class MainController < ApplicationController
  def index
  end

  def logout
    CASClient::Frameworks::Rails::Filter.logout(self)
  end
end
