require "test_helper"

describe OrderitemsController do
  before do
    @user = User.create(name: "rachel", email_address: "rachel@ajonisle.com", uid: "420")
    @product = Product.create(name: "box sofa", description: "a sofa that is a box", price: 400, inventory: 6, photo_url: "https://villagerdb.com/images/items/thumb/box-sofa.fa03062.png", active: true, user_id: @user.id)
    @order = Order.create(status: "pending", name: "Arthur", email_address: "arthur@ajonisle.com", address: "222 Waterfall Way", city: "Ajon", state: "HI", zipcode: "22222", cc_num: "1234567890123", cc_exp_month: "12", cc_exp_year: "2023", cc_cvv: "123", order_date: Time.now) 
    @orderitem = OrderItem.create(order_id: @order.id, product_id: @product.id, quantity: 1)
  end

  describe "create" do
    it "it creates a cart if session doesn't have one" do
      Order.destroy_all
      OrderItem.destroy_all

      expect _(Order.count).must_equal 0
      expect {post orderitems_path(@product.id)}.must_differ "OrderItem.count", 1
      expect _(Order.count).must_equal 1

      expect(session[:cart]).must_be_instance_of Array
      expect(session[:cart].length).must_equal 0
    end

    it "successfully adds an item to a cart if available" do

      expect(flash.now[:status]).must_equal :success
      expect(flash.now[:result_text]).must_equal "Item added to shopping cart."
      must_respond_with :redirect
      must_redirect_to cart_path
    end

    it "gives user a warning if no inventory left, does not add to cart" do
      product = Product.find(id: @orderitem.product_id)
      product.inventory = 0

      expect(flash.now[:status]).must_equal :error
      expect(flash.now[:result_text]).must_equal "There is no inventory left. Item cannot be added to cart."
      must_respond_with :redirect
      must_redirect_to cart_path
    end

    it "adds an order item to the cart" do
      expect(flash.now[:success]).must_equal "#{product.name} was successfully added! 😄"
      must_respond_with :redirect
      must_redirect_to product_path(product)
    end

    it "will give an error if unable to update orderitem" do

      expect(flash.now[:error]).must_equal "A problem occurred: Could not update #{@orderitem.name} - : #{@orderitem.errors.messages}"
      must_respond_with :bad_request
      assert_template :new
    end
  end

  describe "increase_quantity" do
    it "increases quanitity of an item in your cart" do

      expect(flash.now[:success]).must_equal "Item added to shopping cart."
    end

    it "doesn't allow you to add more items than there is inventory" do
      
      expect(flash.now[:error]).must_equal "Unable to add item to shopping cart."
    end
  end

  describe "decrease_quantity" do
    it "decreases quantity of an item in your cart" do

      expect(flash.now[:success]).must_equal "Item removed from shopping cart."
      must_respond_with :redirect
      must_redirect_to fallback_location
    end

    it "doesn't allow you to remove items past 0" do
      
      expect(flash.now[:error]).must_equal "Cart error. Quantity cannot fall below 1."
    end
  end
end
