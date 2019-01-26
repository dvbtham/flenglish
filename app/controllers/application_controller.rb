class ApplicationController < ActionController::Base
  include SessionsHelper

  protect_from_forgery with: :exception

  def logged_in_user
    return if logged_in?
    flash[:danger] = t :please_login
    redirect_to login_path
  end
end
