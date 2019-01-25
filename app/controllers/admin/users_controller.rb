class Admin::UsersController < Admin::BaseController
  before_action :load_options_pairs, only: :index

  def index
    search_params = params.slice :term, :role, :gender
    search_params[:gender] = correct_gender if params[:gender].present?
    @users = User.filter(search_params).paginate page: params[:page],
      per_page: Settings.home.users
    respond_to do |format|
      format.html
      format.js
    end
  end

  private
  def load_options_pairs
    @roles = User.roles
    @genders = User.genders
  end

  def correct_gender
    if params[:gender] == Settings.gender.male_text
      Settings.gender.male
    else
      Settings.gender.female
    end
  end
end
