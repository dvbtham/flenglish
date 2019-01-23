class ErrorsController < ApplicationController
  def show
    status_code = params[:code] || Settings.error_status.internal
    render status_code, status: status_code
  end
end
