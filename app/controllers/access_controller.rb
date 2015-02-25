class AccessController < ApplicationController
  skip_before_action :confirm_logged_in, only: [:signup, :login, :create, :attempt_login]
  before_action :prevent_login_signup, only: [:signup, :login]

  def signup
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "You are now logged in!"
      redirect_to root_path
    else
      render :signup
    end
  end

  def login
  end

  def attempt_login

    if params[:username].present? && params[:password].present?
      found_user = User.find_by_username params[:username]
      if found_user
        authorized_user = found_user.confirm params[:password]
      end
    end

    if !found_user
      flash.now[:alert] = "Invalid username"
      render :login

    elsif !authorized_user
      flash.now[:alert] = "Invalid password"
      render :login

    else
      session[:user_id] = authorized_user.id
      redirect_to root_path, flash: {success: "You are now logged in."}
    end

  end

  def home

  end


  def logout
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to login_path
  end

  private
  def user_params
    params.require(:user).permit(:username, :password, :password_digest)
  end

  def prevent_login_signup
    if session[:user_id]
      redirect_to home_path
    end
  end
end
