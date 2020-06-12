class PagesController < ApplicationController
  def home
  end

  def search
    if params[:search].blank?
      redirect_to(root_path, alert: "Empty field!")
      return
    end

    @parameter = params[:search].downcase  
    # @categories = Category.where("name LIKE ? ", "%#{parameter}%")   #TODO

    @products = Product.where("lower(name) LIKE ? ", "%#{@parameter}%")  
    @categories = Category.where("lower(name) LIKE ? ", "%#{@parameter}%")  
    @users = User.where("lower(name) LIKE ? ", "%#{@parameter}%")  
  end
end

# search - reference: https://melvinchng.github.io/rails/SearchFeature.html#43-adding-a-simple-search-feature
