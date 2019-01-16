class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :email
      t.string :password_digest
      t.boolean :gender
      t.date :date_of_birth
      t.string :reset_digest
      t.datetime :reset_sent_at
      t.string :remember_digest
      t.boolean :activated
      t.datetime :activated_at
      t.string :activation_digest
      t.integer :role, default: 0, null: false
      t.timestamps
    end
  end
end
