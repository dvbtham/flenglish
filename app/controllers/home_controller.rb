class HomeController < ApplicationController
  def index
    @home = Home.new
    @home.feature_movies = Movie.features.newest.paginate(page: params[:page],
      per_page: Settings.home.movies)
    @home.levels = Level.includes :movies
    respond_to do |format|
      format.html
      format.json{render json: @home.feature_movies}
      format.js
    end
  end
end
