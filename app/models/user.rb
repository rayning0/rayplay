class User < ActiveRecord::Base
  has_many :videos, through: :playlist
  has_many :playlist, ->{ order 'position DESC' }, class_name: 'Playlist'

  validates :uid, uniqueness: true

  def self.from_omniauth(auth)
    user = User.find_or_initialize_by(uid: auth['uid'])
    user.name = auth['info']['name']
    user.token = auth['credentials']['token']
    user.save!
    user
  end
end
