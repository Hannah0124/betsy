require "test_helper"

describe Product do
  describe "initialize" do
    before do
      # @user = User.create(name: "test user", email_address: "test_email@example.com")
      @new_product = Product.new(
        name: "Sea Bass", description: "how about a c+", price: 400, inventory: 9, photo_url: "https://villagerdb.com/images/items/thumb/sea-bass-model.7217621.png", active: true
      )
    end

    it "can be instantiated" do
      p "!!"
      p @new_product.valid?
      expect(@new_product.valid?).must_equal true
    end

    it "has required fields" do
      [:name, :description, :price, :inventory, :photo_url, :active].each do |field|
        expect(@new_product).must_respond_to field
      end
    end
  end

  describe "validations" do
    before do
      @product = Product.create(name: "Ninja Hood", description: "ninja hood hat", price: 800, inventory: 3, photo_url: "https://villagerdb.com/images/items/full/ninja-hood.84ef32d.png", active: true)
    end

    describe "name" do
      it "must have a name" do
        @product.name = nil

        expect(@product.valid?).must_equal false
        expect(@product.errors.messages).must_include :name
        expect(@product.errors.messages[:name]).must_equal ["can't be blank"]
      end

      it "must have a unique name" do
        same_product = Product.create(name: "Ninja Hood", description: "ninja hood hat", price: 800, inventory: 3, photo_url: "https://villagerdb.com/images/items/full/ninja-hood.84ef32d.png", active: true)
        
        expect(same_product.valid?).must_equal false
        expect(same_product.errors.messages).must_include :name
        expect(same_product.errors.messages[:name]).must_equal ["has already been taken"]
      end
    end
    
    describe "price" do
      it "must have a price" do
        @product.price = nil

        expect(@product.valid?).must_equal false
        expect(@product.errors.messages).must_include :price
        expect(@product.errors.messages[:price]).must_equal ["can't be blank", "is not a number"]
      end

      it "must have a price that is an integer" do
        @product.price = "sjc"

        expect(@product.valid?).must_equal false
        expect(@product.errors.messages).must_include :price
        expect(@product.errors.messages[:price]).must_equal ["is not a number"]
      end

      it "price cannot be less than 0" do
        @product.price = -1

        expect(@product.valid?).must_equal false
        expect(@product.errors.messages).must_include :price
        expect(@product.errors.messages[:price]).must_equal ["must be greater than 0"]
      end
    end

    describe "inventory" do
      it "must have an inventory count that is not less than zero" do
        @product.inventory = -1

        expect(@product.valid?).must_equal false
        expect(@product.errors.messages).must_include :inventory
        expect(@product.errors.messages[:inventory]).must_equal ["must be greater than 0"]
      end
    end
  end

  describe "relationships" do
    describe "user" do
      
    end
  end

  describe "custom methods" do
    before do
      @product = Product.create(name: "Sea Bass", description: "how about a c+", price: 400, inventory: 9, photo_url: "https://villagerdb.com/images/items/thumb/sea-bass-model.7217621.png", active: true)
      @product2 = Product.create(name: "Ninja Hood", description: "ninja hood hat", price: 800, inventory: 3, photo_url: "https://villagerdb.com/images/items/full/ninja-hood.84ef32d.png", active: false)
      @review1 = Review.create(description: "annoying fish", rating: 1, reviewer: "camden", product_id: @product.id)
      @review2 = Review.create(description: "i hate the pun", rating: 2, reviewer: "everyone", product_id: @product.id)
    end

    describe "change_status" do
      it "changes product status to false if previously true" do
        @product.change_status

        expect(@product.active).must_equal false
      end

      it "changes product status to true if previously false" do
        @product2.change_status

        expect(@product2.active).must_equal true
      end

      # it "changes a product status to false when inventory hits 0" do
      #   @product.inventory = 0

      #   expect(@product.active).must_equal false
      # end
    end

    describe "num_of_ratings" do
      it "calculates number of ratings" do
        expect(@product.num_of_ratings).must_be_instance_of Integer
        expect(@product.num_of_ratings).must_equal 2
      end

      it "returns nothing if there are no ratings" do
        expect(@product2.num_of_ratings).must_equal 0
      end
    end

    describe "average_rating" do
      it "returns a products average rating based on all reviews" do
        expect(@product.average_rating).must_equal 1.5
        expect(@product.average_rating).must_be_instance_of Float
      end

      it "returns an average rating of 0 if there are no ratings" do
        expect(@product2.average_rating).must_equal 0
        expect(@product2.average_rating).must_be_instance_of Integer
      end
    end
  end
end
