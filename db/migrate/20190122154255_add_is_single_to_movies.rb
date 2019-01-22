class AddIsSingleToMovies < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :is_single, :boolean, default: false, after: :views
  end
end
