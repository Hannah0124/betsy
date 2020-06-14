class OrdersController < ApplicationController
  before_action :find_order, only: [:show, :edit, :cart, :update]

  def show
    if @order.nil?
      redirect_back(fallback_location: root_path)
      return
    end
    
    if @order.status == "pending"
      redirect_to cart_path
      return
    end

    user_verification
  end


  private

  def order_params
    return params.require(:order).permit(:status, :name, :email_address, :address, :city, :state, :zipcode, :cc_num, :cc_exp_month, :cc_exp_year, :cc_cvv, :order_date, :user_id)
  end

  def find_order
    @order = Order.find_by(id: params[:id])
  end

  def user_verification
    order_users = []
    @order.order_items.each do |order_item|
      user = order_item.user

      order_users << user
    end

    unless order_users.include?(session[:user_id]) || cookies[:completed_order]
      redirect_to root_path
      return
    end
  end
end
