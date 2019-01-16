class CreateUserMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :user_movies do |t|
      t.integer :movie_id
      t.integer :user_id
      t.integer :views
      t.boolean :status
    end
  end
end
