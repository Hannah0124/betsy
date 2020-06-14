require "test_helper"

# describe ReviewsController do
#   let (:new_product) {products(:t_rex_tail)}

#   describe "unauthenticated" do
#     # describe "new" do
#     #   it 'can see the form to add a review' do
#     #     get new_product_review_path(new_product.id)
        
#     #     must_respond_with :success
#     #   end
#     # end

#     describe "create" do   
#       it "can create a review" do 
#         review_hash = {
#           review:{
#             product_id: new_product.id,
#             reviewer: "Kyle",
#             rating: 2,
#             comment: "It's amazing"
#           }
#         }
        
#         expect {post product_reviews_path(new_product.id), params: review_hash}.must_differ "Review.count", 1
        
#         must_respond_with :redirect
#         must_redirect_to product_path(id: new_product.id)     
#       end
      
#       it "will not create a new review if invalid fields are given" do 
#         review_hash = {
#           review:{
#             reviewer: "Tiffany",
#             product_id: new_product.id, 
#             rating: nil,
#             comment: nil
#           }
#         }
        
#         expect { 
#           post product_reviews_path(new_product.id), params: review_hash
#         }.wont_change "Review.count"
        
#         expect(flash.now[:error]).must_equal "A problem occurred: Could not update the review"
#         must_respond_with :bad_request 
#       end
#     end
#   end
# end
