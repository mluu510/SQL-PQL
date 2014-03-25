module SessionsHelper
  def current_user
    user_id = session[:user_id]
    if (user_id)
      @user ||= User.find(user_id)
    else
      @user = nil
    end
  end


end
