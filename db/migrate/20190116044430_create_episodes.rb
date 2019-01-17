class CreateEpisodes < ActiveRecord::Migration[5.2]
  def change
    create_table :episodes do |t|
      t.integer :movie_id
      t.string :video_url
      t.timestamps
    end
  end
end
