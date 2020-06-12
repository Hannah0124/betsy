class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]
  around_action :render_404, only: [:show, :edit, :update, :destroy], if: -> { @product.nil? }
  helper_method :current_user

  def index 
    @products = Product.all
  end

  def show 
  end

  def new 
    @product = Product.new
  end

  def create 
    @product = Product.new(product_params)
    @user = current_user

    @user.products << @product

    if @product.save 
      flash[:status] = :success
      flash[:result_text] = "#{@product.name} was successfully added! 😄"
      redirect_to product_path(@product)
      return 
    else 
      flash[:status] = :failure
      flash.now[:warning] = "A problem occurred: Could not update #{@product.name}"
      render :new 
      return
    end
  end

  def edit 
  end 

  def update 
    if @product.update(product_params)
      flash[:status] = :success
      flash[:result_text] = "#{@product.name} was successfully edited! 😄"
      redirect_to product_path(@product.id)
      return
    else 
      flash[:status] = :failure
      flash.now[:warning] = "The product was not successfully edited :("
      render :edit 
      return
    end
  end

  def destory 
    if @product.destroy
      flash[:success] = "Successfully destroyed album #{@product.id}"
      redirect_to products_path 
      return
    end
  end


  private 

  def product_params 
    return params.require(:product).permit(:name, :description, :inventory, :price, :photo_url, :active)
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
