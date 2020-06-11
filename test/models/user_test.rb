require "test_helper"

describe User do
  describe "initialize" do
    before do
      @new_user = User.new(name: "Marina", email_address: "marina@ajonisle.com", uid: 43523)
    end

    it "can be instantiated" do
      expect(@new_user.valid?).must_equal true
    end
    
    it "has required fields" do
      [:name, :email_address, :uid].each do |field|
        expect(@new_user).must_respond_to field
      end
    end
  end

  describe "validations" do
    before do
      @user = User.create(name: "Sterling", email_address: "sterling@ajonisle.com", uid: 65429)
    end

    describe "name" do
      it "must have a name" do
        @user.name = nil

        expect(@user.valid?).must_equal false
        expect(@user.errors.messages).must_include :name
        expect(@user.errors.messages[:name]).must_equal ["can't be blank"]
      end

      it "must have a unique name" do
        same_user = User.create(name: "Sterling", email_address: "sterlin@ajonisle.com", uid: 65439)
        
        expect(same_user.valid?).must_equal false
        expect(same_user.errors.messages).must_include :name
        expect(same_user.errors.messages[:name]).must_equal ["has already been taken"]
      end
    end

    describe "email_address" do
      it "must have an email_address" do
        @user.email_address = nil
 
        expect(@user.valid?).must_equal false
        expect(@user.errors.messages).must_include :email_address
        expect(@user.errors.messages[:email_address]).must_equal ["can't be blank"]
      end
 
      it "must have a unique email_address" do
        same_user = User.new(name: "Sterlin", email_address: "sterling@ajonisle.com", uid: 65499)
         
        expect(same_user.valid?).must_equal false
        expect(same_user.errors.messages).must_include :email_address
        expect(same_user.errors.messages[:email_address]).must_equal ["has already been taken"]
      end
    end

    describe "uid" do
      it "must have an uid" do
        @user.uid = nil
 
        expect(@user.valid?).must_equal false
        expect(@user.errors.messages).must_include :uid
        expect(@user.errors.messages[:uid]).must_equal ["can't be blank"]
      end
 
      it "must have a unique uid" do
        same_user = User.new(name: "Sterli", email_address: "sterli@ajonisle.com", uid: 65429)
         
        expect(same_user.valid?).must_equal false
        expect(same_user.errors.messages).must_include :uid
        expect(same_user.errors.messages[:uid]).must_equal ["has already been taken"]
      end
    end
  end

  describe "relationships" do
    before do
      @user = User.new(name: "Roland", email_address: "roland@ajonisle.com", uid: 76293)
    end

    it "can be created without a product" do
      expect(@user.save).must_equal true
    end

    it "can have a product" do
      @user.save
      product = Product.create(name: "Graduation Gown", description: "congrats on your graduation", price: 3360, inventory: 3, photo_url: "https://villagerdb.com/images/items/full/graduation-gown.6e38324.png", active: true)
    
      expect(@user.products.first).must_be_instance_of Product
      expect(@user.products.first.name).must_equal product.name
    end
  end
end
