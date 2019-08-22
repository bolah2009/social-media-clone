# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes_given, foreign_key: :user_id, class_name: 'Like',
                         dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, -> { where('confirmed = ?', true) }, through: :friendships

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.password = Devise.friendly_token[0, 20]
      user.image = auth.info.image
    end
  end

  validates :name, presence: true

  def liked?(post_id)
    likes_given.where('post_id = ?', post_id).any?
  end

  def pending_requests
    Friendship.where('friend_id = ? AND confirmed = ?', id, false)
  end

  def sent_requests
    Friendship.where('user_id = ? AND confirmed = ?', id, false)
  end

  def sent_request?(user)
    sent_requests.where('friend_id = ?', user.id).any?
  end

  def pending_request?(user)
    pending_requests.where('user_id = ?', user.id).any?
  end

  def friend?(user)
    friends.include?(user)
  end

  def feed
    friend_ids = "SELECT friend_id FROM friendships
                     WHERE  user_id = :user_id AND confirmed = true"
    Post.where("user_id IN (#{friend_ids})
                     OR user_id = :user_id", user_id: id)
  end
end
