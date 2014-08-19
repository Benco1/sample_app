module SessionsHelper

  def sign_in(user)
  	remember_token = User.new_remember_token
  	# Creates token
  	cookies.permanent[:remember_token] = remember_token
  	# Places raw token in browser cookies
  	# permanent = 20.years.from_now
  	user.update_attribute(:remember_token, User.digest(remember_token))
  	# Saves hashed token to db while by-passing validation (update_attribute)
  	# b/c password/confirmation not relevant or available here
  	self.current_user = user
  	# Set current user to given user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end
  # Above method required in lieu of conventional getter method b/c current_user
  # will be set to nil with each subsequent request. Therefore, if @current_user
  # is nil, the instance variable will be recalled through cross-referencing 
  # hashed browser cookie against that stored in db.

  def current_user?(user)
    user == current_user
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.digest(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end
end