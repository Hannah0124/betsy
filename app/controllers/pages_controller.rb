class PagesController < ApplicationController
  def home
  end

  def frontpage
    products = Product.all
    @spotlight = []

    products.each do |product|
      if product.reviews.length > 1
        @spotlight << product
      end 
    end
    @spotlight = @spotlight.sort_by {|obj| obj.reviews.length}
    @spotlight[0..9]
  end

end

# search - reference: https://melvinchng.github.io/rails/SearchFeature.html#43-adding-a-simple-search-feature
