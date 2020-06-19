class OrderitemsController < ApplicationController
  
  def index
  end

  # Reference: https://stackoverflow.com/questions/7980438/saving-cart-object-during-one-session

  def create
    if !session[:cart]
      session[:cart] = Array.new
    end 

    product = Product.find_by(id: params["product_id"])
    quantity = params["quantity"].to_i

    session[:cart].each do |item|
      if item['product_id'] == product.id && item['quantity'] < product.inventory
        item["quantity"] += 1
        flash[:status] = :success
        flash[:result_text] = "Item added to shopping cart."
        redirect_to cart_path
        return
      else
        flash[:status] = :error
        flash[:result_text] = "There is no inventory left. Item cannot be added to cart."
        redirect_to cart_path
        return 
      end
    end

    # session[:cart] << product
    @orderitem = OrderItem.new(
      quantity: quantity,
      product_id: product.id
    )

    if @orderitem.save 
      session[:cart] << @orderitem
      flash[:success] = "#{product.name} was successfully added! 😄"
      redirect_to product_path(product)
      return 
    else 
      flash.now[:error] = "A problem occurred: Could not update #{@orderitem.name} - : #{@orderitem.errors.messages}"
      render :new, status: :bad_request
      return
    end

    # flash[:status] = :success
    # flash[:result_text] = "Item added to shopping cart."
    flash[:success] = "Item added to shopping cart."
    redirect_to cart_path
    return 
  end

# Why +/- are in the controller, not model: https://guides.rubyonrails.org/v4.1.4/action_controller_overview.html#accessing-the-session

  def increase_quantity
    return "You have nothing in your cart. :( " if !session[:cart]

    product = Product.find_by(id: params["format"]).inventory

    session[:cart].each do |item|
      if item["product_id"] == params['format'].to_i && item['quantity'] < product
        item["quantity"] += 1
        # flash[:status] = :success
        # flash[:result_text] = "Item added to shopping cart."
        flash[:success] = "Item added to shopping cart."
      else
        # flash[:result_text] = "No product stock left."
        flash[:error] = "Unable to add item to shopping cart."
      end
    end

    fallback_location = orderitems_path
    redirect_back(fallback_location: fallback_location)
  end

  def decrease_quantity
    return "You have nothing in your cart. :( " if !session[:cart]

    session[:cart].each do |item|
      if item["product_id"] == params['format'].to_i
        item["quantity"] > 1 ? item["quantity"] -= 1 : session[:cart].delete(item)
      end

      if item["quantity"] == 0
        # flash[:status] = :error
        # flash[:result_text] = "Cart error. Quantity cannot fall below 1."
        flash[:error] = "Cart error. Quantity cannot fall below 1."
      end
    end

    # flash[:status] = :success
    # flash[:result_text] = "Item removed from shopping cart."
    flash[:success] = "Item removed from shopping cart."
    fallback_location = orderitems_path
    redirect_back(fallback_location: fallback_location)
  end
end
