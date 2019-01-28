class MoviesController < ApplicationController
  include UsersHelper

  before_action :load_genres_pairs, :load_levels_pairs, :load_categories_pairs,
    only: :search
  before_action :load_movie, only: %i(show watch)
  before_action :load_episode, :logged_in_user, only: :watch

  def show
    @episode_id = @movie.episodes.any? ? @movie.episodes.first.id : 0
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
    params[:tab] = Settings.tab.default if params[:tab].nil?
    @subtitles = @episode.subtitles
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
end
