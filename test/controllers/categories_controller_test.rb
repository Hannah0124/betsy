require "test_helper"

describe CategoriesController do
  describe "unauthenticated user" do
    describe "index" do
      it "should respond with success" do
        get categories_path

        must_respond_with :success
      end

      it "doesn't break if no categories" do
        Category.destroy_all
        get categories_path

        must_respond_with :success
      end
    end
  end

  describe "authenticated user" do
    before do 
      login(users(:user1))
    end

    describe "index" do
      it "should respond with success" do
        get categories_path

        must_respond_with :success
      end

      it "doesn't break if no categories" do
        Category.destroy_all
        get categories_path

        must_respond_with :success
      end
    end



  end
end
