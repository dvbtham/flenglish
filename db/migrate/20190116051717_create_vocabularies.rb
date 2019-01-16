class CreateVocabularies < ActiveRecord::Migration[5.2]
  def change
    create_table :vocabularies do |t|
      t.integer :movie_id
      t.integer :dictionary_id
      t.boolean :status
      t.timestamps
    end
  end
end
