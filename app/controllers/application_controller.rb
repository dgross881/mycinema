class ApplicationController < ActionController::Base
  protect_from_forgery

  def require_user 
    redirect_to sign_in_path unless current_user 
  end 
  
  def signed_in? 
    current_user 
  end 
  helper_method :signed_in?

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end 
  helper_method :current_user 
end
