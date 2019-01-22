class MoviesController < ApplicationController
  before_action :load_genres_pairs, :load_levels_pairs, :load_categories_pairs,
    only: :search

  def show; end

  # render to json for autocomplete search
  def movies
    @movies = Movie.term params[:term]
    render json: @movies.select(:title_en, :title_vi)
  end

  def search
    search_params = params.slice :term, :level, :genre, :category, :column_sort
    @movies = Movie.filter(search_params).paginate(page: params[:page],
      per_page: Settings.home.movies)
    @sort_by = Movie.filterable_columns
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
end
