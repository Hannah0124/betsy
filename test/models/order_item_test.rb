require "test_helper"

describe OrderItem do
  let (:user) { User.create(name: "Kat", email_address: "kat@ajonisle.com", uid: 32432)}
  let (:product) {Product.create(name: "box sofa", description: "a sofa that is a box", price: 400, inventory: 2, photo_url: "https://villagerdb.com/images/items/thumb/box-sofa.fa03062.png", active: true, user_id: user.id)}
  let (:order) {Order.create(status: "pending")}
  let (:orderitem) {OrderItem.create(order_id: order.id, product_id: product.id, quantity: 1)}
  let (:pending_order) {Order.create(status: "pending", name: "Marina the Octopus", email_address: "marina@ajonisle.com", address: "222 Waterfall Way", city: "Ajon", state: "HI", zipcode: "22222", cc_num: "1234567890123", cc_exp_month: "12", cc_exp_year: "2023", cc_cvv: "123", order_date: Time.now)}

  describe "initialize" do
    it "can be instantiated" do
      expect(orderitem.valid?).must_equal true 
    end

    it "has required fields" do
      orderitem.save

      [:order_id, :product_id, :quantity, :complete].each do |field|
        expect(orderitem).must_respond_to field
      end
    end
  end

  describe "validations" do
    # it "must have order_id" do
    #   orderitem.order_id = nil
    #   orderitem.save

    #   expect(orderitem.valid?).must_equal false
    #   expect(orderitem.errors.messages).must_include :order_id
    #   expect(orderitem.errors.messages[:order_id]).must_equal ["can't be blank"]
    # end

    it "must have a product_id" do
      orderitem.product_id = nil
      orderitem.save
      
      expect(orderitem.valid?).must_equal false
      expect(orderitem.errors.messages).must_include :product_id
      expect(orderitem.errors.messages[:product_id]).must_equal ["can't be blank", "is not a number"]
    end

    it "must have a valid product_id" do
      orderitem.product_id = -1
      orderitem.save
      
      expect(orderitem.valid?).must_equal false
      expect(orderitem.errors.messages).must_include :product_id
      expect(orderitem.errors.messages[:product_id]).must_equal ["must be greater than 0"]
    end
    
    it "must have a quantity" do
      orderitem.quantity = nil
      orderitem.save
      
      expect(orderitem.valid?).must_equal false
      expect(orderitem.errors.messages).must_include :quantity
      expect(orderitem.errors.messages[:quantity]).must_equal ["can't be blank", "is not a number"]
    end
    
    it "must have a quantity greater than 0" do
      orderitem.quantity = 0
      orderitem.save
      
      expect(orderitem.valid?).must_equal false
      expect(orderitem.errors.messages).must_include :quantity
      expect(orderitem.errors.messages[:quantity]).must_equal ["must be greater than 0"]
    end
    
    it "has a default for complete as false" do
      orderitem.save
      
      expect(orderitem.valid?).must_equal true
      expect(orderitem.complete).must_equal false
    end
  end

  # describe "relationship" do
  #   it "has an order" do
  #     orderitem.save
  #     expect(orderitem.order).must_be_instance_of Order
  #   end

  #   it "has a product" do
  #     orderitem.save
  #     expect(orderitem.product).must_be_instance_of Product
  #   end
  # end

  describe "custom methods" do

    # describe "total" do
    #   it "returns the total of orderitem" do
    #     total = orderitem.total
    #     expect(total).must_equal (orderitem.quantity * orderitem.product.price)
    #   end
    # end

    # describe "mark_cancelled" do
    #   it "changes order_item.complete to nil" do
    #     orderitem.complete = false
    #     orderitem.save
        
    #     expect(orderitem.complete).must_equal false
    #     orderitem.mark_cancelled
    #     assert_nil(orderitem.complete)
    #   end

    #   it "will change inventory" do
    #     orderitem.complete = false
    #     orderitem.save

    #     beg_product_qty = orderitem.product.inventory
    #     beg_orderitem_qty = orderitem.quantity 

    #     expect(orderitem.complete).must_equal false
    #     orderitem.mark_cancelled
    #     expect(orderitem.product.inventory).must_equal (beg_product_qty + beg_orderitem_qty)
    #   end
    # end

    # describe "mark_complete" do
    #   it "correctly changes orderitem.complete to true" do
    #     orderitem.complete = false
    #     orderitem.save
        
    #     expect(orderitem.complete).must_equal false
    #     orderitem.mark_complete
    #     expect(orderitem.complete).must_equal true
    #   end
    # end

    # describe "exists" do
    #   it "returns orderitem object if it exists" do
    #     orderitem.save
    #     exists = OrderItem.exists?(order.id, product.id)

    #     expect(exists.id).must_equal orderitem.id
    #     expect(exists.order_id).must_equal orderitem.order_id
    #     expect(exists.product_id).must_equal orderitem.product_id
    #     expect(exists.complete).must_equal orderitem.complete  
    #   end
      
    #   it "returns false if orderitem does not exist" do
    #     orderitem.save
    #     exists = OrderItem.exists?(-1, -1)

    #     expect(exists).must_equal false
    #   end
    # end

    # TODO
    describe "OrderItem.cart_count" do 
      it "returns the number of items in the cart" do 
        session = Hash.new
        session[:cart] = [{'product_id' => 12, 'quantity' => 5}]

        expect(OrderItem.cart_count(session).to_i).must_equal 5
      end
    end
  end
end
