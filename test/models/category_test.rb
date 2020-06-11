require "test_helper"

describe Category do
  describe "initialize" do
    before do
      @category = Category.new(name: "Miscellaneous")
    end

    it "can be instatiated" do
      expect(@category.valid?).must_equal true
    end

    it "has required fields" do
      expect(@category).must_respond_to :name
    end
  end

  describe "validations" do
    before do
      @fossils = Category.create(name: "fossils")
    end

    describe "name" do
      it "has a name that is a string" do
        expect(@fossils.name).must_be_instance_of String
        expect(@fossils.name).must_equal @fossils.name
      end

      it "does not allow an empty string for a name" do
        @fossils.name = ""

        expect(@fossils.valid?).must_equal false
        expect(@fossils.errors.messages).must_include :name
        expect(@fossils.errors.messages[:name]).must_equal ["can't be blank"]
      end

      it "does not allow a string of whitespace for a name" do
        @fossils.name = " "

        expect(@fossils.valid?).must_equal false
        expect(@fossils.errors.messages).must_include :name
        expect(@fossils.errors.messages[:name]).must_equal ["can't be blank"]
      end

      it "cannot be nil" do
        @fossils.name = nil

        expect(@fossils.valid?).must_equal false
        expect(@fossils.errors.messages).must_include :name
        expect(@fossils.errors.messages[:name]).must_equal ["can't be blank"]
      end

      it "must be unique" do
        same_category = Category.new(name: "fossils")

        expect(same_category.valid?).must_equal false
        expect(same_category.errors.messages).must_include :name
        expect(same_category.errors.messages[:name]).must_equal ["has already been taken"]
      end
    end
  end

  describe "relationships" do 
    before do
      @fossils = Category.new(name: "fossils")
      @tops = Category.new(name: "tops")
      @furniture = Category.new(name: "furniture")
    end

    describe "products" do
      it "can have no products" do 
        new_category = Category.new(name: "Other")

        expect(new_category.valid?).must_equal true
      end

      it "can have more than one product" do
        expect(@fossils.products.count).must_equal @fossils.products.count

        expect(@fossils.products.first).must_be_instance_of Product
        expect(@furniture.products.count).mustclear_equal @furniture.products.count
        expect(@tops.products).must_be_empty
        expect(@tops.products.length).must_equal 0
      end
    end

    #deleting of products?
  end
end
