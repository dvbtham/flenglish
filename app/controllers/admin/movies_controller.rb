class Admin::MoviesController < Admin::BaseController
  before_action :load_options_pairs, only: %i(index edit)
  before_action :load_movie, only: %i(edit update)

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

  def edit; end

  def update
    Movie.transaction do
      @movie.update_attributes! movie_params
    end
    flash[:success] = t "update_success.movie"
    redirect_to_condition = params[:button] == Settings.continue
    redirect_to edit_admin_movie_path @movie if redirect_to_condition
    redirect_to admin_movies_path unless redirect_to_condition
  rescue ActiveRecord::RecordNotSaved
    flash.now[:danger] = t :save_error
    render :edit
  end

  def load_subtitles
    @subtitles = Subtitle.load_subtitles params[:episode]
    respond_to do |format|
      format.js
    end
  end

  private

  def movie_params
    params.require(:movie).permit :title_en, :title_vi, :description,
      :image_url, :category_id, :level_id, :total_episodes, :is_feature,
      :views, :is_single, :rating, genre_ids: Array.new
  end

  def load_movie
    @movie = Movie.find_by id: params[:id]
    return if @movie
    flash[:danger] = t "not_found.movie"
    redirect_to page_404_path
  end

  def load_options_pairs
    @genres = Genre.key_value_pairs
    @levels = Level.key_value_pairs
    @categories = Category.key_value_pairs
  end

  def column_valid? param
    Movie.filterable_columns.flatten.include? param.to_sym if param.present?
  end
end
