class CreateUserVocabularies < ActiveRecord::Migration[5.2]
  def change
    create_table :user_vocabularies do |t|
      t.integer :user_id
      t.integer :movie_id
      t.integer :dictionary_id

      t.timestamps
    end
  end
end
