class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy, :toggle_status]
  around_action :render_404, only: [:show, :edit, :update, :destroy, :toggle_status], if: -> { @product.nil? }
  helper_method :current_user

  def index 
    @products = Product.all
  end

  def show 
  end

  def new 
    if @login_user
      @product = Product.new
    else 
      flash["error"] = "A problem occurred: You must log in to add a product"
    end
  end

  def create 
    @product = Product.new(product_params)

    # @login_user.products << @product

    if @product.save 
      flash[:success] = "#{@product.name} was successfully added! 😄"
      redirect_to product_path(@product)
      return 
    else 
      flash.now[:error] = "A problem occurred: Could not update #{@product.name}"
      render :new 
      return
    end
  end

  def edit 
  end 

  def update 
    if @product.update(product_params)
      flash[:success] = "#{@product.name} was successfully edited! 😄"
      redirect_to dashboard_path
      return
      # redirect_back(fallback_location: dashboard_path)
      # return
    else 
      flash.now[:error] = "The product was not successfully edited :("
      render :edit 
      return
    end
  end

  def toggle_status
    if @product.change_status
      redirect_to dashboard_path
      return
    end 
  end


  # TODO
  def destroy
    if @product.destroy
      flash[:success] = "Successfully destroyed product #{@product.id}"
      redirect_to products_path 
      return
    end
  end

  private 

  def product_params 
    return params.require(:product).permit(:name, :description, :inventory, :price, :photo_url, :active, :user_id, category_ids: [])
  end

  def find_product
    product_id = params[:id]
    @product = Product.find_by(id: product_id) 
  end

  def render_404 
    render :file => "#{Rails.root}/public/404.html", layout: false, status: :not_found
    return 
  end
end
