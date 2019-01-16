class CreateSuggests < ActiveRecord::Migration[5.2]
  def change
    create_table :suggests do |t|
      t.integer :user_id
      t.string :movie_name
      t.string :movie_url
      t.string :description
      t.boolean :viewed
      t.timestamps
    end
  end
end
