class ProductsController < ApplicationController
  helper_method :current_user, :render_404, :require_login

  before_action :find_product, only: [:show, :edit, :update, :destroy, :toggle_status]
  
  around_action :require_login, only: [:new, :create, :edit, :update, :destroy, :toggle_status], if: -> { !@login_user }
  around_action :render_404, only: [:show, :edit, :update, :destroy, :toggle_status], if: -> { @product.nil? }
  around_action :check_authorization, only: [:edit, :update, :destroy, :toggle_status], if: -> { @login_user && @login_user != @product.user }
  
  

  def index 
    @products = Product.where(active: true).order(:name)
  end

  def show 
  end

  def new 
    @product = Product.new
  end

  def create 
    @product = Product.new(product_params)
    @product.user_id = @login_user.id   

    if @product.save 
      flash[:success] = "#{@product.name} was successfully added! 😄"
      redirect_to product_path(@product)
      return 
    else 
      flash.now[:error] = "A problem occurred: Could not update #{@product.name} - : #{@product.errors.messages}"
      render :new, status: :bad_request
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
    else 
      flash.now[:error] = "The product was not successfully edited :("
      render :edit, status: :bad_request 
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

    if !@product.user_id
      flash.now[:error] = "A problem occurred: You are not authorized to perform this action"
      redirect_back(fallback_location: products_path)  
      return 
    end

    if @product.destroy
      flash[:success] = "Successfully destroyed product #{@product.id}"
      redirect_to products_path 
      return
    end
  end

  private 

  def product_params 
    return params.require(:product).permit(:name, :description, :inventory, :price, :photo_url, :active, category_ids: [])
  end

  def find_product
    product_id = params[:id]
    @product = Product.find_by(id: product_id) 
  end

  def check_authorization 
    if @login_user && @login_user != @product.user
      flash.now[:error] = "A problem occurred: You are not authorized to perform this action. This is not your product."
      redirect_to dashboard_path 
      return 
    end
  end
end
