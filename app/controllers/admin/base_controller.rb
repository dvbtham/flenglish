class Admin::BaseController < ApplicationController
  layout "admin"

  before_action :authenticate_user!, :verify_admin

  private

  def verify_admin
    return if current_user.try :administrator?
    raise CanCan::AccessDenied
  end
end
