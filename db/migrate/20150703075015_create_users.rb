class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :token
      t.string :uid

      t.timestamps null: false
    end
    add_index :users, :uid, unique: true
  end
end
