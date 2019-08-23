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

  has_many :pending_requests, -> { where(confirmed: false).order(created_at: :desc) },
           foreign_key: :friend_id, class_name: 'Friendship'
  has_many :pending_friends, through: :pending_requests, source: :user

  has_many :sent_requests, -> { where confirmed: false }, foreign_key: :user_id, class_name: 'Friendship'
  has_many :sent_friends, through: :sent_requests, source: :friend

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true

  def liked?(post_id)
    likes_given.where('post_id = ?', post_id).any?
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

  def pending_friends_notification
    pending_friends.limit(5)
  end
end
