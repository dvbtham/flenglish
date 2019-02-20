class Admin::BaseController < ApplicationController
  layout "admin"

  before_action :admin_user

  def admin_user
    return if user_signed_in? && current_user.administrator?
    flash[:alert] = t :unaccessable
    redirect_to new_session_path
  end
end
