require "test_helper"

describe Product do
  describe "initialize" do
    before do
      @new_product = Product.new(name: "Sea Bass", description: "how about a c+", price: 400, inventory: 9, photo_url: "https://villagerdb.com/images/items/thumb/sea-bass-model.7217621.png", active: true)
    end

    it "can be instantiated" do
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
      product = Product.create(name: "Ninja Hood", description: "ninja hood hat", price: 800, inventory: 3, photo_url: "https://villagerdb.com/images/items/full/ninja-hood.84ef32d.png", active: true)
    end

    describe "name" do
      it "must have a name" do
        product.name = nil

        expect(product.valid?).must_equal false
        expect(product.errors.messages).must_include :name
        expect(product.errors.messages[:name]).must_equal ["can't be blank"]
      end

      it "must have a unique name" do
        same_product = Product.create(name: "Ninja Hood", description: "ninja hood hat", price: 800, inventory: 3, photo_url: "https://villagerdb.com/images/items/full/ninja-hood.84ef32d.png", active: true)
        
        expect(same_product.valid?).must_equal false
        expect(same_product.errors.messages).must_include :name
        expect(same_product.errors.messages[:name]).must_equal ["product already exists"]
      end
    end
    
    describe "price" do
      it "must have a price" do
        product.price = nil

        expect(product.valid?).must_equal false
        expect(product.errors.messages).must_include :price
        expect(product.errors.messages[:price]).must_equal ["can't be blank", "is not a number"]
      end

      it "has a price greater than 0" do
        product.price = -1

        expect(product.valid?).must_equal false
        expect(product.errors.messages).must_include :price
        expect(product.errors.messages[:price]).must_equal ["must be greater than 0"]
      end
    end

    describe "inventory" do
      it "must have an inventory count greater than 0" do
        product.inventory = -1

        expect(product.valid?).must_equal false
        expect(product.errors.messages).must_include :inventory
        expect(product.errors.messages[:inventory).must_equal ["can't be less than zero"]
      end
    end
  end

  describe "relationships" do
    
  end

  
  it "returns empty array if no products" do
    no_products = Product.destroy_all

    expect(no_products).must_equal []
  end
end
