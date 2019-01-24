class Admin::MoviesController < Admin::BaseController
  before_action :load_options_pairs, only: :index

  def index
    search_params = params.slice :term, :level, :genre, :category, :column_sort
    search_params.delete :column_sort unless column_valid? params[:column_sort]
    @movies = Movie.filter(search_params).paginate page: params[:page],
      per_page: Settings.home.movies
    @sort_by = Movie.filterable_columns
    respond_to do |format|
      format.html
      format.js
    end
  end

  private
  def load_options_pairs
    @genres = Genre.key_value_pairs
    @levels = Level.key_value_pairs
    @categories = Category.key_value_pairs
  end

  def column_valid? param
    Movie.filterable_columns.flatten.include? param.to_sym if param.present?
  end
end
