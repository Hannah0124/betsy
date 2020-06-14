require "test_helper"

describe ProductsController do
  describe "unauthenticated user" do
    describe "index" do
      it "responds with success when there are products" do
        get products_path
        
        must_respond_with :success
      end
      
      it "responds with success when there are no products" do
        Product.destroy_all
        get products_path
        
        must_respond_with :success
      end
    end

    describe "new" do
      it "does not show the form to create new product" do
        get new_product_path
        
        expect(flash[:error]).must_equal "A problem occurred: You must log in to add a product"
      end
    end
  end

  describe "authenticated user" do
    before do
      login(users(:user1))
    end

    describe "new" do
      it "shows form for new product" do
        get new_product_path
        
        must_respond_with :success
      end
    end

    describe "create" do
      it "creates a new product given valid information" do      
        product = {
          product: {
            name: "Apron Skirt", 
            description: "for all your cooking!",
            price: 700, 
            inventory: 3,
            photo_url: "https://villagerdb.com/images/items/full/apron-skirt.fa97145.png",
            active: true,
            user_id: users(:user2).id
          }
        }
        
        expect {post products_path, params: product}.must_differ "Product.count", 1
        
        new_product = Product.last
        
        expect(new_product.name).must_equal product[:product][:name]
        expect(flash.now[:success]).must_equal "#{new_product.name} was successfully added! 😄"
        must_respond_with :redirect
        must_redirect_to product_path(new_product)
      end
      
      it "doesn't create a new product if given invalid information" do
        invalid_product = {
          product: {
            name: nil, 
            description: "for all your cooking!",
            price: 700, 
            inventory: 3,
            photo_url: "https://villagerdb.com/images/items/full/apron-skirt.fa97145.png",
            active: true,
            user_id: users(:user2).id
          }
        }
        
        expect {post products_path, params: invalid_product}.wont_change "Product.count"
        expect(flash.now[:error]).must_equal "A problem occurred: Could not update #{invalid_product[:product][:name]}"
        assert_template :new
      end
    end

  end
end
