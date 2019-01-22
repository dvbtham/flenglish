class AddNameToEpisodes < ActiveRecord::Migration[5.2]
  def change
    add_column :episodes, :name, :string, after: :movie_id
  end
end
