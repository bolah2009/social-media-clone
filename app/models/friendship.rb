class Friendship < ApplicationRecord

  after_create :create_mutual_friendship
  after_destroy :destroy_mutual_friendship

  belongs_to :user
  belongs_to :friend, class_name: 'User'

  def create_mutual_friendship
    friend.friendships.first_or_create(friend: user)
  end

  def destroy_mutual_friendship
    friendship = friend.friendships.find_by(friend_id: user)
    friendship&.destroy
  end
end
