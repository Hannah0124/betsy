require "test_helper"

describe Review do
  describe "initialize" do
    before do
      @review = Review.new(description: "very good thing", rating: 5)
    end
    
    it "can be instantiated" do
      expect(@review.valid?).must_equal true
      expect(@review).must_be_instance_of Review
    end

    it "has required fields" do
      @review.save

      [:description, :rating].each do |field|
        expect(@review).must_respond_to field
      end
    end
  end

  describe "validations" do
    before do 
      @new_review = Review.create(description: "horrible, what a crooked tanooki", rating: 1)
    end

    it "must have a description" do
      @new_review.description = nil

      expect(@new_review.valid?).must_equal false
      expect(@new_review.errors.messages).must_include :description
      expect(@new_review.errors.messages[:description]).must_equal ["can't be blank"]
    end

    describe "rating" do
      it "must have a rating" do
        @new_review.rating = nil

        expect(@new_review.valid?).must_equal false
        expect(@new_review.errors.messages).must_include :rating
        expect(@new_review.errors.messages[:rating]).must_equal ["can't be blank"]
      end

      it "must be a number" do
        @new_review.rating = "sdf"

        expect(@new_review.valid?).must_equal false
        expect(@new_review.errors.messages).must_include :rating
        expect(@new_review.errors.messages[:rating]).must_equal ["is not a number"]
      end

      it "must be greater than 0" do
        @new_review.rating = 0

        expect(@new_review.valid?).must_equal false
        expect(@new_review.errors.messages).must_include :rating
        expect(@new_review.errors.messages[:rating]).must_equal ["must be between 1 and 5"]
      end

      it "must be less than 6" do
        @new_review.rating = 9

        expect(@new_review.valid?).must_equal false
        expect(@new_review.errors.messages).must_include :rating
        expect(@new_review.errors.messages[:rating]).must_equal ["must be between 1 and 5"]
      end
    end
  end
end
