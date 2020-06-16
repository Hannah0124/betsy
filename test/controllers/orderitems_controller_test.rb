require "test_helper"

describe OrderitemsController do
  let (:user) {User.create(name: "rachel", email_address: "rachel@ajonisle.com", uid: "420")}
  let (:product) {Product.create(name: "box sofa", description: "a sofa that is a box", price: 400, inventory: 2, photo_url: "https://villagerdb.com/images/items/thumb/box-sofa.fa03062.png", active: true, user_id: user.id)}
  let (:order) {Order.create(status: "pending", name: "Arthur", email_address: "arthur@ajonisle.com", address: "222 Waterfall Way", city: "Ajon", state: "HI", zipcode: "22222", cc_num: "1234567890123", cc_exp_month: "12", cc_exp_year: "2023", cc_cvv: "123", order_date: Time.now)}  
  let (:orderitem) {OrderItem.create(order_id: order.id, product_id: product.id, quantity: 1)}

  
end
