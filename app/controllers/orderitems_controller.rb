class OrderitemsController < ApplicationController

  before_action :find_order_item, only: [:create]

  def index
  end

  # Reference: https://stackoverflow.com/questions/7980438/saving-cart-object-during-one-session

  def create
    if !session[:cart]
      session[:cart] = Array.new
    end 

    product = Product.find_by(id: params["product_id"])


    # if product.inventory > 1 || !product.active
    quantity = params["quantity"].to_i

    session[:cart].each do |item|
      if item['product_id'] == product.id 
        if item['quantity'] < product.inventory
          item["quantity"] += 1
          flash[:success] = "Item added to shopping cart."  # due to UI
          redirect_to cart_path
          return
        elsif item['quantity'] == product.inventory
          flash[:error] = "There is no inventory left. Item cannot be added to cart."
          redirect_to cart_path
          return 
        end
      end
    end

    @orderitem = OrderItem.new(
      quantity: quantity,
      product_id: product.id,
    )

    if @orderitem.save 
      session[:cart] << @orderitem
      flash[:success] = "#{product.name} was successfully added to shopping cart! 😄"
      redirect_to product_path(product)
      return 
    else 
      flash.now[:error] = "A problem occurred: Could not update #{@orderitem.name} - : #{@orderitem.errors.messages}"
      render :new, status: :bad_request
      return
    end



    # flash[:status] = :error
    # flash[:result_text] = "There is no inventory left. Item cannot be added to cart."

    flash[:error] = "There is no inventory left. Item cannot be added to cart."

    redirect_to product_path(product)
    return 
  end

# Why +/- are in the controller, not model: https://guides.rubyonrails.org/v4.1.4/action_controller_overview.html#accessing-the-session

  def increase_quantity
    return "You have nothing in your cart. :( " if !session[:cart]

    product = Product.find_by(id: params["format"]).inventory
  

    session[:cart].each do |item|
      if item["product_id"] == params['format'].to_i && item['quantity'] < product
        item["quantity"] += 1
        flash[:success] = "Item added to shopping cart."
      elsif item["product_id"] == params['format'].to_i && item['quantity'] == product
        flash[:error] = "WARNING: There is no inventory left. No additional items can be added to cart."
      end
    end

    fallback_location = orderitems_path
    redirect_back(fallback_location: fallback_location)
    return
  end

  def decrease_quantity
    return "You have nothing in your cart. :( " if !session[:cart]

    session[:cart].each do |item|
      if item["product_id"] == params['format'].to_i
        item["quantity"] > 1 ? item["quantity"] -= 1 : session[:cart].delete(item)
      end

      if item["quantity"] == 0
        flash[:error] = "Cart error. Quantity cannot fall below 1."
      end
    end

    flash[:success] = "Item removed from shopping cart."
    fallback_location = orderitems_path
    redirect_back(fallback_location: fallback_location)
  end

  private 

  def find_order_item 
    @order_item = OrderItem.find_by(id: params[:id])
  end
end



        # elsif item['product_id'] == product.id && item['quantity'] == product.inventory
      #   flash[:status] = :error
      #   flash[:result_text] = "There is no inventory left. Item cannot be added to cart."
      #   redirect_to cart_path
      #   return 
      # else
                # session[:cart] << product