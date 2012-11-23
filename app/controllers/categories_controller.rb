class CategoriesController < ApplicationController
  
  def all
    categories = Category.all
    render json: categories
  end
  
end
