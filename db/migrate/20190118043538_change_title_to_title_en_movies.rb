class ChangeTitleToTitleEnMovies < ActiveRecord::Migration[5.2]
  def change
    rename_column :movies, :title, :title_en
  end
end
