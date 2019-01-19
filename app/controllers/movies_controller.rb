class MoviesController < ApplicationController
  def show; end

  def search
    @search = Search.new
    search_params = params.slice :term, :level, :genre, :category, :column_sort
    @search.movies = Movie.filter(search_params).paginate(page: params[:page],
      per_page: Settings.home.movies)
    @search.genres = Genre.key_value_pairs
    @search.levels = Level.key_value_pairs
    @search.categories = Category.key_value_pairs
    @search.sort_by = Movie.filterable_columns
  end
end
