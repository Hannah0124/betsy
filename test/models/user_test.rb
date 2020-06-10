require "test_helper"

describe User do
  describe "initialize" do
    before do
      @new_user = User.new(name: "Marina", email: "marina@ajonisle.com", uid: 43523)
    end

    it "can be instantiated" do
      expect(@new_user.valid?).must_equal true
    end
    
    it "has required fields" do
      [:name, :email, :uid].each do |field|
        expect(@new_merchant).must_respond_to field
    end
  end
end
