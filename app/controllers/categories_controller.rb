class CategoriesController < ApplicationController

  def all
    categories = Category.all
    render json: categories
  end

  def show
    category = Category.find(params[:id])
    render json: category
  end

  def search
    query = params[:query]
    categories = Category.fulltext_search(query)
    render json: categories
  end

  def events
    @category = Category.find(params[:id])
    if params[:start_at] && params[:end_at]
      @events = @category.events_with_period(params[:start_at], params[:end_at])
    else
      @events = @category.events
        .order("start_at")
    end
    render json: @events.as_json
  end

end
