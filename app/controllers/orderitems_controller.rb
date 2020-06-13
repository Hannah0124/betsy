class OrderitemsController < ApplicationController
  
  def create
    if !session[:cart]
      session[:cart] = Array.new
    end 

    session[:cart] << params["product_id"]
    flash[:status] = :success
    flash[:result_text] = "Item added to shopping cart."
    redirect_to product_path(params["product_id"])
    return 
  end


end
