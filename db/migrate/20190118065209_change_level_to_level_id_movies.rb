class ChangeLevelToLevelIdMovies < ActiveRecord::Migration[5.2]
  def change
    rename_column :movies, :level, :level_id
  end
end
