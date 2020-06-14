class ProductsController < ApplicationController
  helper_method :current_user, :render_404

  before_action :find_product, only: [:show, :edit, :update, :destroy, :toggle_status]
  around_action :render_404, only: [:show, :edit, :update, :destroy, :toggle_status], if: -> { @product.nil? }
  around_action :valid_user, only: [:new, :create, :edit, :update], if: -> { @login_user.nil? }
  

  def index 
    @products = Product.where(active: true).order(:name)
  end

  def show 
  end

  def new 
    if @login_user
      @product = Product.new
    end
  end

  def create 
    @product = Product.new(product_params)
    @product.user_id = @login_user.id

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
    if @login_user.id != @product.user_id
      flash.now[:error] = "A problem occurred: Could not edit another merchant's product"
      redirect_to dashboard_path 
      return 
    end
  end 

  def update 
    if @product.update(product_params)
      flash[:success] = "#{@product.name} was successfully edited! 😄"
      redirect_to dashboard_path
      return
    else 
      flash.now[:error] = "The product was not successfully edited :("
      render :edit 
      return
    end
  end

  def toggle_status
    if @product.change_status
      flash[:success] = "#{@product.name}'s status was successfully updated! 😄"
      redirect_to dashboard_path
      return
    end 
  end

  def search
    if params[:search].blank?
      redirect_to(root_path, alert: "Empty field!")
      return
    end

    @parameter = params[:search].downcase  
    @products = Product.where("lower(name) LIKE ? ", "%#{@parameter}%")  
    @categories = Category.search(@parameter)  
    @users = User.where("lower(name) LIKE ? ", "%#{@parameter}%")  
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

  def valid_user
    if !@login_user
      flash.now[:error] = "A problem occurred: You must log in to add a product"
      redirect_back(fallback_location: products_path) 
      return
    end
  end
end
