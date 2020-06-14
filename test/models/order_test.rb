require "test_helper"

describe Order do
  let (:user) {User.create(name: "rachel", email: "rachel@ajonisle.com", uid: "420")}
  let (:product) {Product.create(name: "box sofa", description: "a sofa that is a box", price: 400, inventory: 2, photo_url: "https://villagerdb.com/images/items/thumb/box-sofa.fa03062.png", active: true, user_id: user.id}
  let (:product2) {Product.create(name: "pedal board", description: "a pedal board", price: 150, inventory: 3, photo_url: "https://villagerdb.com/images/items/thumb/pedal-board.ff406c9.png", active: true, user_id: user.id)}
  let (:order) {Order.create(status: "pending", name: "Marina the Octopus", email_address: "marina@ajonisle.com", address: "222 Waterfall Way", city: "Ajon", state: "HI", zipcode: "22222", cc_num: "1234567890123", cc_exp_month: "12", cc_exp_year: "2023", cc_cvv: "123", order_date: Time.now )}  
  let (:order2) {Order.create(status: "pending")}
  let (:orderitem1) {Orderitem.create(order_id: order.id, product_id: product.id, quantity: 1) }
  let (:orderitem2) {Orderitem.create(order_id: order.id, product_id: product2.id, quantity: 2) }
  let (:orderitem3) {Orderitem.create(order_id: order.id, product_id: product2.id, quantity: 2, complete: true) }

  describe "validations" do
    
  end
end
