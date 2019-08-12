class Post < ApplicationRecord

  belongs_to  :user
  has_many    :comments, dependent: :destroy
  has_many    :likes, dependent: :destroy

  default_scope -> {order(created_at: :desc)}

  validates :content, presence: true
end
