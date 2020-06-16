class ReviewsController < ApplicationController
  def new
    @review = Review.new
  end

  def create
    product = Product.find_by(id: find_product.id)

    if @login_user && (@login_user.id == product.user_id)
      flash[:error] = "A problem occurred: Cannot add a review for your own product!"
      redirect_to product_path(product.id)
      return
    else

    if @login_user 
      @review = Review.new(
        rating: params[:rating],
        description: params[:description],
        product_id: params[:product_id],
        reviewer: @login_user.name
      )
    else 
      @review = Review.new(review_params) 
    end
    
    if @review.save
      flash[:success] = "The review was successfully added! 😄"
    else
      flash[:error] = "A problem occurred: Could not update the review"
    end

    redirect_back(fallback_location: root_path)
    return
  end
end

  private

  def review_params
    params.permit(:rating, :description, :product_id, :reviewer)
  end

  def find_product
    return Product.find_by(id: params[:product_id])
  end
end