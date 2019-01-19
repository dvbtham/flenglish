class MoviesController < ApplicationController
  def show; end

  # render to json for autocomplete search
  def movies
    @movies = Movie.term params[:term]
    render json: @movies.select(:title_en, :title_vi)
  end

  def search
    @search = Search.new
    search_params = params.slice :term, :level, :genre, :category, :column_sort
    @search.movies = Movie.filter(search_params).paginate(page: params[:page],
      per_page: Settings.home.movies)
    @search.genres = Genre.key_value_pairs
    @search.levels = Level.key_value_pairs
    @search.categories = Category.key_value_pairs
    @search.sort_by = Movie.filterable_columns
    respond_to do |format|
      format.html
      format.js
    end
  end
end
