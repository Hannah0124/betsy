class ApplicationController < ActionController::Base
  before_action :set_users


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_users
      @users = User.all
    end
  before_action :find_user 

  def render_404
    # DPR: this will actually render a 404 page in production
    raise ActionController::RoutingError.new("Not Found")
  end

  def find_user 
    if session[:user_id]
      @login_user = User.find_by(id: session[:user_id])
    end
  end
end
