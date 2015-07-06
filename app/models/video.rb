class Video < ActiveRecord::Base
  has_many :users, through: :playlists
  has_many :playlist, ->{ order 'position DESC' }

  YT_LINK_FORMAT = /\A.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/i
  validates :link, presence: true, format: YT_LINK_FORMAT
  validates :uid, uniqueness: true
end
