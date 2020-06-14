require "test_helper"

describe Order do
  let (:user) {User.create(name: "rachel", email_address: "rachel@ajonisle.com", uid: "420")}
  let (:product) {Product.create(name: "box sofa", description: "a sofa that is a box", price: 400, inventory: 2, photo_url: "https://villagerdb.com/images/items/thumb/box-sofa.fa03062.png", active: true, user_id: user.id)}
  let (:product2) {Product.create(name: "pedal board", description: "a pedal board", price: 150, inventory: 3, photo_url: "https://villagerdb.com/images/items/thumb/pedal-board.ff406c9.png", active: true, user_id: user.id)}
  let (:order) {Order.create(status: "pending", name: "Marina the Octopus", email_address: "marina@ajonisle.com", address: "222 Waterfall Way", city: "Ajon", state: "HI", zipcode: "22222", cc_num: "1234567890123", cc_exp_month: "12", cc_exp_year: "2023", cc_cvv: "123", order_date: Time.now)}  
  let (:order2) {Order.create(status: "pending")}
  let (:orderitem) {OrderItem.create(order_id: order.id, product_id: product.id, quantity: 1)}
  let (:orderitem2) {OrderItem.create(order_id: order.id, product_id: product2.id, quantity: 2)}
  let (:orderitem3) {OrderItem.create(order_id: order.id, product_id: product2.id, quantity: 2, complete: true)}

  describe "validations" do
    
  end

  describe "total" do
    it "returns total for order with no orderitems" do
      result = order.total
      
      expect(result).must_equal 0
    end
    
    it "returns total for an order with one orderitem" do
      order.save
      orderitem.save
      
      result = order.total
      expected_result = orderitem.quantity * orderitem.product.price
      
      expect(result).must_equal expected_result
    end
    
    it "returns total for order with more than one orderitems" do
      order.save
      orderitem.save
      orderitem2.save
      
      result = order.total
      expected_result = orderitem.quantity * orderitem.product.price + orderitem2.quantity * orderitem2.product.price
      
      expect(result).must_equal expected_result
    end
  end

  describe "card_expired_check" do
    
  end

  describe "status_check" do
    before do
      order = Order.create(status: "pending", name: "Marina the Octopus", email_address: "marina@ajonisle.com", address: "222 Waterfall Way", city: "Ajon", state: "HI", zipcode: "22222", cc_num: "1234567890123", cc_exp_month: "12", cc_exp_year: "2023", cc_cvv: "123", order_date: Time.now)
      @order = Order.find_by(name: "Marina the Octopus")

      @orderitem1 = OrderItem.create(order_id: order.id, product_id: product.id, quantity: 1, complete: false)
      @orderitem2 = OrderItem.create(order_id: order.id, product_id: product2.id, quantity: 1, complete: true)
    end

    it "doesnt mark order complete if all items are not complete: true" do
      expect(@order.status).must_equal "pending"
      @order.status_check

      expect(@order.status).must_equal "pending"
    end

    it "marks an order as complete if all items are complete: true" do
      expect(@order.status).must_equal "pending"
      @orderitem1.update(complete: true)
      @order.status_check

      expect(@order.status).must_equal "complete"
    end

    it "marks an order as cancelled if call orderitems are marked as cancelled" do
      expect(@order.status).must_equal "pending"
      @orderitem1.update(complete: nil)
      @orderitem2.update(complete: nil)
      @order.status_check

      expect(@order.status).must_equal "cancelled"
    end

    it "doesnt mark order cancelled unless all orderitems are marked as cancelled" do
      expect(@order.status).must_equal "pending"
      @orderitem1.update(complete: nil)
      @orderitem2.update(complete: false)
      @order.check_status

      expect(@order.status).must_equal "pending"
    end
  end
end
