require "test_helper"

describe PagesController do
  it "must get home" do
    get pages_home_url
    must_respond_with :success
  end

  describe "search" do
    it "shows error message if blank search" do
      search = {
        params: 
        {"search"=>""}
      }

      get search_path, params: search
      
      expect(flash[:alert]).must_equal "Empty field!"
      must_respond_with :redirect
      must_redirect_to root_path
    end

    it "shows search results when not blank field" do
      search = {
        params: 
        { "search"=>"a"}
      }

      get search_path, params: search

      must_respond_with :redirect
    end
  end
end
