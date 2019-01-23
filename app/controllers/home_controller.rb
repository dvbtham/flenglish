class HomeController < ApplicationController
  def index
    @feature_movies = Movie.features.newest.paginate(page: params[:page],
      per_page: Settings.home.movies)
    @levels = Level.includes :movies
    respond_to do |format|
      format.html
      format.json{render json: @feature_movies}
      format.js
    end
  end
end
