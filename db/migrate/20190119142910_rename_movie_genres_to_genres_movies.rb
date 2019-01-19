class RenameMovieGenresToGenresMovies < ActiveRecord::Migration[5.2]
  def change
    rename_table :movie_genres, :genres_movies
  end
end
