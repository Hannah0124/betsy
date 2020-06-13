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

    describe "new" do
      it "gets the new category path" do
        get new_category_path

        must_respond_with :success
      end
    end

    describe "create" do
      it "creates a new category" do
        new_category_params = {
          category: {
            name: "miscellaneous"
          }
        }
        
        expect{post categories_path, params: new_category_params}.must_change "Category.count", 1

        new_category = Category.find_by(name: new_category_params[:category][:name])

        expect(new_category.name).must_equal new_category_params[:category][:name]
        must_redirect_to category_path(new_category)
      end

      it "doesn't create a new category when name is nil" do
        new_category_params = {
          category: {
            name: nil
          }
        }

        expect{post categories_path, params: new_category_params}.wont_change "Category.count"
        expect(flash.now[:error]).must_equal "A problem occurred: Could not update #{new_category_params[:category][:name]}"
        assert_template :new
      end
    end



  end
end
