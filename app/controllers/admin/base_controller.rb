class Admin::BaseController < ApplicationController
  layout "admin"

  before_action :admin_user

  def admin_user
    return if logged_in? && current_user.administrator?
    flash[:danger] = t :unaccessable
    redirect_to login_path
  end
end
