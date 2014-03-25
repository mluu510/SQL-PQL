# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  provider   :string(255)      not null
#  uid        :string(255)      not null
#  nickname   :string(255)
#  name       :string(255)
#  email      :string(255)
#  avatar_url :string(255)
#

class User < ActiveRecord::Base
  validates :provider, :uid, presence: true
  validates :uid, uniqueness: true

  def self.from_omniauth(auth)
    provider = auth['provider']
    uid = auth['uid']
    user = User.find_by_provider_and_uid(provider, uid)
    if (user)
      return user
    else
      user = User.new
      user.provider = provider
      user.uid = uid
      info = auth['info']
      user.nickname = info['nickname']
      user.name = info['name']
      user.email = info['email']
      user.avatar_url = info['image']
      user.save!
      return user
    end
  end


end
