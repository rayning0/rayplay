class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.references :video, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
