module SessionsHelper
  # Logs in the given user
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # Remember a user in a persistent session
  def remember(user)
    # the remember method on the user object updates the remember_digest field
    # in the database with the hashed value of the remember_token
    user.remember  
    # the next two lines assign the encrypted id and remember_token in the
    # cookie to save in the browser
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # Returns the current logged in user (if any)
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end
  
  # Logs out the current user
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
