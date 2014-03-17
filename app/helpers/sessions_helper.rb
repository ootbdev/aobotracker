module SessionsHelper

  def user_logged_in?
    cookies.has_key?(:user_id) && !cookies[:user_id].empty?
  end

  def verify_session
    if cookies.has_key?(:user_id) && !cookies[:user_id].empty?
      @current_user = User.find_by_id(cookies[:user_id])
    end
    redirect_to login_path unless @current_user
  end

end
