class UsersController < ApplicationController
  before_action :authenticate_user!, :load_user, only: :show

  def show; end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "not_found.user"
    redirect_to page_404_path
  end
end
