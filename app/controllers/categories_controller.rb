class CategoriesController < ApplicationController
  before_action :find_category, only: [:show]
  around_action :render_404, only: [:show], if: -> { @category.nil? }

  def index 
    @categories = Category.all.order(:name)
  end

  def show 
  end

  private 

  def category_params 
    return params.require(:category).permit(:name)
  end

  def find_category
    category_id = params[:id]
    @category = Category.find_by(id: category_id) 
  end

  def render_404 
    render :file => "#{Rails.root}/public/404.html", layout: false, status: :not_found
    return 
  end
end
