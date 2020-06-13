class ApplicationController < ActionController::Base
  before_action :set_users


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_users
      @users = User.all
    end
  before_action :find_user 

  def render_404 
    render :file => "#{Rails.root}/public/404.html", layout: false, status: :not_found
    return 
  end

  def find_user 
    if session[:user_id]
      @login_user = User.find_by(id: session[:user_id])
    end
  end

  def current_user
    return User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_login
    if current_user.nil?
      flash[:error] = "You must be logged in to do that"
      redirect_to root_path
    end
  end
end
