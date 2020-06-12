class PagesController < ApplicationController
  def home
  end

  def search
    if params[:search].empty?  
      redirect_to(root_path, alert: "Empty field!")
      return
    end

    @products = Product.where("name LIKE ? ", "%#{params[:search]}%")  
    @categories = Category.where("name LIKE ? ", "%#{params[:search].capitalize}%")  
    @users = User.where("name LIKE ? ", "%#{params[:search].capitalize}%")  
  end
end

# search - reference: https://melvinchng.github.io/rails/SearchFeature.html#43-adding-a-simple-search-feature
