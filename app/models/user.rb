# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes_given, foreign_key: :user_id, class_name: 'Like',
                         dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true

  def liked?(post_id)
    likes_given.where('post_id = ?', post_id).any?
  end
end
