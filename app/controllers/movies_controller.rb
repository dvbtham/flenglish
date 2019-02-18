class MoviesController < ApplicationController
  include UsersHelper

  before_action :load_genres_pairs, :load_levels_pairs, :load_categories_pairs,
    only: :search
  before_action :load_movie, only: %i(show watch)
  before_action :authenticate_user!, :load_episode, only: :watch

  def show
    @comment = Comment.new if user_signed_in?
    @comments = @movie.comments_with_pagination params[:page]
    @episode_id = @movie.episodes.any? ? @movie.episodes.first.id : 0
    respond_to do |format|
      format.html{render :show}
      format.js{render file: Settings.shared.file.js.comment}
    end
  end

  def search
    search_params = params.slice :term, :level, :genre, :category, :column_sort
    search_params.delete :column_sort unless column_valid? params[:column_sort]
    @movies = Movie.filter(search_params).paginate page: params[:page],
      per_page: Settings.home.movies
    @sort_by = Movie.filterable_columns
  end

  # render to json for autocomplete search
  def load_movies_to_json
    @movies = Movie.term params[:term]
    render json: @movies.select(:title_en, :title_vi)
  end

  def watch
    view_counter_cookie = "#{current_user.id}_#{@movie.id}"
    params[:tab] = Settings.tab.default if params[:tab].nil?
    @subtitles = @episode.subtitles
    return if cookies[:view_counter] == view_counter_cookie
    add_view_counter @movie
    cookies[:view_counter] = {value: view_counter_cookie,
                              expires: Time.now + Settings.view_counter.hours}
  end

  private

  def load_genres_pairs
    @genres = Genre.key_value_pairs
  end

  def load_levels_pairs
    @levels = Level.key_value_pairs
  end

  def load_categories_pairs
    @categories = Category.key_value_pairs
  end

  def column_valid? param
    Movie.filterable_columns.flatten.include? param.to_sym if param.present?
  end

  def load_movie
    @movie = Movie.find_by id: params[:id]
    return if @movie
    flash[:danger] = t "not_found.movie"
    redirect_to page_404_path
  end

  def load_episode
    @episode = @movie.episodes.find_by id: params[:episode]
    return if @episode
    flash[:danger] = t "not_found.episode"
    redirect_to page_404_path
  end

  def add_view_counter movie
    user_movie = UserMovie.find_by user_id: current_user.id, movie_id: movie.id
    UserMovie.transaction do
      if user_movie
        user_movie.views = user_movie.views + Settings.step.one
        user_movie.save!
      else
        user_movie = UserMovie.create!(user_id: current_user.id,
          movie_id: movie.id, views: Settings.default_views)
      end
      movie.update_attributes! views: user_movie.views
    end
  rescue ActiveRecord::RecordNotSaved
    flash.now[:danger] = t :save_error
    render :watch
  end
end
