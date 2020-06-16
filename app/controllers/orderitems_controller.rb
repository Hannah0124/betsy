class OrderitemsController < ApplicationController
  
  def index
    
  end

  # Reference: https://stackoverflow.com/questions/7980438/saving-cart-object-during-one-session

  def create
    if !session[:cart]
      session[:cart] = Array.new
    end 

    product = Product.find_by(id: params["product_id"]).id
    quantity = params["quantity"].to_i

    # session[:cart] << product

    session[:cart] << OrderItem.create(
        quantity: quantity,
        product_id: product
      )

    flash[:status] = :success
    flash[:result_text] = "Item added to shopping cart."
    redirect_to product_path(params["product_id"])
    return 
  end

# Why +/- are in the controller, not model: https://guides.rubyonrails.org/v4.1.4/action_controller_overview.html#accessing-the-session

  def increase_quantity
    return "You have nothing in your cart. :( " if !session[:cart]

    product = Product.find_by(id: params["format"]).inventory
    # quantity = params["quantity"].to_i

    session[:cart].each do |item|
      if item["product_id"] == params['format'].to_i && item['quantity'] < product
        item["quantity"] += 1
        flash[:status] = :success
        flash[:result_text] = "Item added to shopping cart."
      else
        flash[:result_text] = "No product stock left."
      end
    end

    fallback_location = orderitems_path
    redirect_back(fallback_location: fallback_location)
  end

  def decrease_quantity
    return "You have nothing in your cart. :( " if !session[:cart]

    # product = Product.find_by(id: params['format'])
    # quantity = params["quantity"].to_i

    session[:cart].each do |item|
      if item["product_id"] == params['format'].to_i 
        item["quantity"] -= 1
      end
    end

    flash[:status] = :success
    flash[:result_text] = "Item removed from shopping cart."
    fallback_location = orderitems_path
    redirect_back(fallback_location: fallback_location)
  end
end
