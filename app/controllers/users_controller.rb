class UsersController < ApplicationController
  helper_method :render_404
  before_action :require_login, only: [:destroy, :dashboard]

  def index
    @users = User.all.order(:name).paginate(:page=>params[:page],:per_page=>15)
  end

  def show
    @user = User.find_by(id: params['id'])

    if @user.nil?
      return render_404 
    end
  end

  def create
    auth_hash = request.env["omniauth.auth"]
    
    user = User.find_by(uid: auth_hash[:uid], provider: 'github')

    if user
      flash[:success] = "Logged in as user #{user.name}"
    else

      user = User.build_from_github(auth_hash)
      
      if user.save
        flash[:success] = "Logged in as new user #{user.name}"
      else
        flash[:error] = "Could not create new user account: #{user.errors.messages}"
        return redirect_to root_path
      end
    end

    session[:user_id] = user.id
    redirect_to dashboard_path
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Successfully logged out!"

    redirect_to root_path
  end

  def dashboard
    @user = User.find_by(id: session[:user_id])
  end

  private

end