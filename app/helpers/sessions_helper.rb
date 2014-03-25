module SessionsHelper
  def current_user
    user_id = session[:user_id]
    @user ||= User.find(user_id)
  end


end
