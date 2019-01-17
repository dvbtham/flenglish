class CreateDictionaries < ActiveRecord::Migration[5.2]
  def change
    create_table :dictionaries do |t|
      t.string :word_en
      t.string :word_vi
      t.string :pronounciation
      t.timestamps
    end
  end
end
