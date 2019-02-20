class ConfirmationsController < Devise::ConfirmationsController
  protected

  def after_resending_confirmation_instructions_path_for resource_name
    new_session_path
  end
end
