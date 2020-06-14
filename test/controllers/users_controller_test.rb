require "test_helper"

describe UsersController do
  describe "unauthenticated" do
    describe "index" do
      it "should display all path" do
        get users_path

        must_respond_with :success
      end

      it "should not break if there are no users" do 
        User.destroy_all
        get users_path
        
        must_respond_with :success
      end
    end

    describe "show" do
      it "responds with success when given a valid user" do
        user1 = users(:user1)
        
        get user_path(user1.id)
        must_respond_with :success
      end
      
      it "respond with redirect with an invalid user" do 
        get user_path(-2)
        
        must_respond_with :redirect
        must_redirect_to users_path
      end
    end
    
    describe "dashboard" do
      it "redirects to root path when user is not logged in" do
        get dashboard_path
        
        
        expect(flash[:error]).must_equal "You must be logged in to do that"
        must_respond_with :redirect
        must_redirect_to root_path
      end
    end
  end

  describe "authenticated" do
    before do
      login(users(:user1))
    end

    describe "dashboard" do
      it "shows dashboard for logged in user" do
        get dashboard_path

        must_respond_with :success
      end
    end

    describe "logout/destroy" do
      it "logs out current user" do
        expect(session[:user_id].nil?).must_equal false

        post logout_path

        assert_nil(session[:user_id])
        expect(flash[:success]).must_equal "Successfully logged out!"
        must_respond_with :redirect
        must_redirect_to root_path
      end
    end
  end

  describe "auth_callback/create" do
    it "logs in user and redirects" do 
      user = users(:user1)
      
      login(user)
      must_respond_with :redirect
      must_redirect_to dashboard_path
      expect(User.find_by(id session[:user_id])).must_equal user
    end

    it "creates account for new user" do
      new_user = User.new(name: "camden", email_address: "camden@ajonisle.com", uid: 666)

      expect{login(new_user)}.must_differ "User.count", 1
      
      expect(User.find_by(id: session[:user_id])).must_equal User.all.last
      
      must_respond_with :redirect
      must_redirect_to dashboard_path
    end

    it "redirects to login route if user data is invalid" do
      new_user = User.new(name: "camden", email_address: "camden@ajonisle.com", uid: nil)
      
      expect{login(new_user)}.wont_change "User.count"
      
      must_respond_with :redirect
      must_redirect_to users_path
    end
  end
end
