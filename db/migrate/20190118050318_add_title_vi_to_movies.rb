class AddTitleViToMovies < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :title_vi, :string, after: :title_en
  end
end
