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


  def increase_quantity
    return "You have nothing in your cart. :( " if !session[:cart]

    # product = Product.find_by(id: params["product_id"]).id
    # quantity = params["quantity"].to_i

    if session[:cart][product]
      session[:cart][product] += 1
    else
      session[:cart][product] = 1
    end

    flash[:status] = :success
    flash[:result_text] = "Item added to shopping cart."
    return 
  end


end
