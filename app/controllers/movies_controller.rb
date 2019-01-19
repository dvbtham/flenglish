class MoviesController < ApplicationController
  def show; end

  def search
    search_params = params.slice :term, :level, :genre, :category, :column_sort
    @movies = Movie.filter(search_params).paginate(page: params[:page],
      per_page: Settings.home.movies)
    @genres = Genre.key_value_pairs
    @levels = Level.key_value_pairs
    @categories = Category.key_value_pairs
    @sort_by = Movie.filterable_columns
  end
end
