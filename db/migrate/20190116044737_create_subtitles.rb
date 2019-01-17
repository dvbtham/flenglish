class CreateSubtitles < ActiveRecord::Migration[5.2]
  def change
    create_table :subtitles do |t|
      t.integer :episode_id
      t.string :vietsub
      t.string :engsub
      t.integer :subtitle_at
      t.timestamps
    end
  end
end
