class OrderitemsController < ApplicationController
  
  def index
    
  end

  # Reference: https://stackoverflow.com/questions/7980438/saving-cart-object-during-one-session

  def create
    if !session[:cart]
      session[:cart] = Hash.new
    end 

    product = Product.find_by(id: params["product_id"]).id
    quantity = params["quantity"].to_i

    # session[:cart] << product

    if session[:cart][product]
      session[:cart][product] += quantity
    else
      session[:cart][product] = quantity
    end

    flash[:status] = :success
    flash[:result_text] = "Item added to shopping cart."
    redirect_to product_path(params["product_id"])
    return 
  end


end
