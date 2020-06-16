require "test_helper"

describe ReviewsController do
  describe "authenticated" do
    describe "create" do   
      before do
        @product = Product.create(user_id: users(:user1).id, name: "Ninja Hood", description: "ninja hood hat", price: 800, inventory: 3, photo_url: "https://villagerdb.com/images/items/full/ninja-hood.84ef32d.png")
      end

      it "can create a review" do 
        review_hash = {
          review:{
            product_id: @product.id,
            reviewer: "Kyle",
            rating: 2,
            description: "It's amazing"
          }
        }

        expect {post product_reviews_path(@product.id), params: review_hash}.must_differ "Review.count", 1
        
        must_respond_with :redirect
        must_redirect_to product_path(id: @product.id)     
      end
      
      it "will not create a new review if invalid fields are given" do 
        review_hash = {
          review:{
            reviewer: "camden",
            product_id: @product.id, 
            rating: nil,
            description: nil
          }
        }
        
        expect {post product_reviews_path(@product.id), params: review_hash}.wont_change "Review.count"
        
        expect(flash.now[:error]).must_equal "A problem occurred: Could not update the review"
        must_respond_with :redirect 
      end
    end
  end
end
