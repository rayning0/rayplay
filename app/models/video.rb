class Video < ActiveRecord::Base
  validates :uid, uniqueness: true
  has_and_belongs_to_many :users

  YT_LINK_FORMAT = /\A.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/i
  validates :link, presence: true, format: YT_LINK_FORMAT
end
