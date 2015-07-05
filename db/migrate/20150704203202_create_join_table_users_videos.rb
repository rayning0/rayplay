class CreateJoinTableUsersVideos < ActiveRecord::Migration
  create_join_table :videos, :users, column_options: {null: true} do |t|
    t.index :video_id
    t.index :user_id
  end
end
