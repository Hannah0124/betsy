require "test_helper"

describe OrderitemsController do
  let (:user) {User.create(name: "rachel", email_address: "rachel@ajonisle.com", uid: "420")}

  let (:product) {Product.create(name: "box sofa", description: "a sofa that is a box", price: 400, inventory: 2, photo_url: "https://villagerdb.com/images/items/thumb/box-sofa.fa03062.png", active: true, user_id: user.id)}

  let (:order) {Order.create(status: "pending", name: "Arthur", email_address: "arthur@ajonisle.com", address: "222 Waterfall Way", city: "Ajon", state: "HI", zipcode: "22222", cc_num: "1234567890123", cc_exp_month: "12", cc_exp_year: "2023", cc_cvv: "123", order_date: Time.now)}  

  let (:orderitem) {OrderItem.create(order_id: order.id, product_id: product.id, quantity: 1)}


  describe "unauthenticated" do 
    describe "create" do 
      it 'can create a new orderitems as a guest user' do 
        order_item_params = {
          quantity: 2,
          product_id: products(:pengsoo_nose).id,
          order_id: order.id
        }

        expect {
          post orderitems_path, params: order_item_params
        }.must_differ 'OrderItem.count', 1

        expect(flash[:success]).must_include "was successfully added to shopping cart! 😄"
      end

      # it 'cannot create a new orderitems if the product is out of stock' do 
      #   order_item_params = {
      #     quantity: 1,
      #     product_id: products(:bunny_nose).id,
      #     order_id: order.id
      #   }

      #   expect {
      #     post orderitems_path, params: order_item_params
      #   }.wont_change 'OrderItem.count'

      #   must_respond_with :redirect 
      #   must_redirect_to frontpage_path

      # end
    end

    describe "increase_quantity" do 
      # TODO
      it "can increase quantity when there is the same item in the cart" do 
        order_item_params = {
          quantity: 2,
          product_id: products(:pengsoo_nose).id,
          order_id: order.id
        }

        post orderitems_path, params: order_item_params

        expect {
          patch add_path(products(:pengsoo_nose).id), params: order_item_params
        }.wont_differ 'OrderItem.count'

        expect(flash[:success]).must_include "Item added to shopping cart."
      end

      # TODO
      it "will throw an error if quantity is greater than its current stock" do 
        order_item_params = {
          quantity: 5,
          product_id: products(:lion_nose).id,
          order_id: order.id
        }

        post orderitems_path, params: order_item_params

        expect {
          patch add_path(products(:lion_nose).id), params: order_item_params
        }.wont_differ 'OrderItem.count'


        # p flash
        # expect(flash[:success]).must_include "Item added to shopping cart."
      end
    end

    # patch '/orderitems/add', to:"orderitems#increase_quantity", as: "add"
    # patch '/orderitems/subtract', to:"orderitems#decrease_quantity", as: "subtract"
    describe "decrease_quantity" do 
    end
  end
  
end
