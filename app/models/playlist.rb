class Playlist < ActiveRecord::Base
  belongs_to :video
  belongs_to :user
  acts_as_list scope: :user
end
