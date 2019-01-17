class CreateRatingMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :rating_movies do |t|
      t.integer :movie_id
      t.integer :user_id
      t.integer :rate
      t.datetime :rated_at
    end
  end
end
