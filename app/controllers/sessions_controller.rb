class SessionsController < ApplicationController
  def create
    user_id = params[:user_id]
    u = User.find_by_id(user_id)
    if u
      cookies[:user_id] = params["user_id"]
      redirect_to home_path
    else
      redirect_to login_path
    end
  end

  def destroy
    cookies.delete(:user_id)
    redirect_to login_path
  end
end
