class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :description
      t.string :image_url
      t.integer :category_id
      t.integer :level
      t.integer :total_episodes
      t.boolean :is_feature
      t.float :rating
      t.integer :views
      t.timestamps
    end
  end
end
