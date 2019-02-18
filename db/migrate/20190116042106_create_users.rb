class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :email, unique: true
      t.boolean :gender
      t.date :date_of_birth
      t.integer :role, default: 0, null: false
      t.timestamps
    end
  end
end
