class Admin::UsersController < Admin::BaseController
  def index
    search_params = params.slice :term
    @users = User.filter(search_params).paginate page: params[:page],
      per_page: Settings.home.users
    respond_to do |format|
      format.html
      format.js
    end
  end
end
