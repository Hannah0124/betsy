class ApplicationController < ActionController::Base
  before_action :set_users


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_users
      @users = User.all
    end
end
