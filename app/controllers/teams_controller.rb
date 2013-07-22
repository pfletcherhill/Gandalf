class TeamsController < ApplicationController
  
  before_filter :require_login
  
  def show
    team = Team.find_by_slug(params[:id])
    render json: team.as_json(include: [:users])
  end
  
  def create
    team = Team.new(params[:team])
    if team.save
      render json: team
    else
      render json: "Group was not created", status: 500
    end
  end
  
end
