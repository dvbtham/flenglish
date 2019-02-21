class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_global_search_variable

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: t(:unaccessable)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up,
      keys: %i(full_name gender date_of_birth)
    devise_parameter_sanitizer.permit :account_update,
      keys: %i(full_name gender date_of_birth)
  end

  private

  def set_global_search_variable
    @search = Movie.ransack params[:q]
  end
end
