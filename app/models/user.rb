class User < ActiveRecord::Base
  validates :uid, uniqueness: true
  has_and_belongs_to_many :videos
  serialize :playlist, Array

  def self.from_omniauth(auth)
    user = User.find_or_initialize_by(uid: auth['uid'])
    user.name = auth['info']['name']
    user.token = auth['credentials']['token']
    user.save!
    user
  end
end
