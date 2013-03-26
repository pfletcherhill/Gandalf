class CategoriesController < ApplicationController

  def all
    categories = Category.all.sort_by { |c| c.name }
    render json: categories
  end

  def show
    category = Category.find(params[:id])
    render json: category
  end

  def show_by_slug
    category = Category.find_by_slug(params[:slug])
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
      @events = @category.complete_events
    end
    render json: @events
  end

end
