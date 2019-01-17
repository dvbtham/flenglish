class CreateMovieFollowings < ActiveRecord::Migration[5.2]
  def change
    create_table :movie_followings do |t|
      t.integer :user_id
      t.integer :movie_id
    end
  end
end
