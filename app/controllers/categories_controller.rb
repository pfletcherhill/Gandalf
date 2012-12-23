class CategoriesController < ApplicationController
  
  def all
    categories = Category.all
    render json: categories
  end
  
  def search
    query = params[:query]
    categories = Category.fulltext_search(query)
    render json: categories
  end
  
end
