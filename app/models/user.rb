# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes_given, foreign_key: :user_id, class_name: 'Like',
                         dependent: :destroy, inverse_of: 'user'

  has_many :friendships, dependent: :destroy
  has_many :friends, -> { where('confirmed = ?', true) }, through: :friendships

  has_many :pending_requests, -> { where(confirmed: false).order(created_at: :desc) },
           foreign_key: :friend_id, class_name: 'Friendship', inverse_of: 'user'
  has_many :pending_friends, through: :pending_requests, source: :user

  has_many :sent_requests, -> { where confirmed: false },
           foreign_key: :user_id, class_name: 'Friendship', inverse_of: 'user'
  has_many :sent_friends, through: :sent_requests, source: :friend

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
    likes_given.where(post_id: post_id).any?
  end

  def sent_request?(user)
    sent_requests.where(friend_id: user.id).any?
  end

  def pending_request?(user)
    pending_requests.where(user_id: user.id).any?
  end

  def feed
    Post.where(user_id: friend_ids + [id])
  end

  def pending_friends_notification
    pending_friends.limit(5)
  end

  def friend?(user)
    friends.include?(user)
  end
end
