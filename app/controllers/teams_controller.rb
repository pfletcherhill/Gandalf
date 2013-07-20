class TeamsController < ApplicationController
  
  before_filter :require_login
  
  def show
    team = Team.find_by_slug(params[:id])
    render json: team.as_json(include: [:users])
  end
  
end
