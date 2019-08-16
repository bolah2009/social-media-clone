# frozen_string_literal: true

class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  def confirm_friend
    return if confirmed

    update(confirmed: true)
    save
    Friendship.create(user_id: friend.id, friend_id: user_id, confirmed: true)
  end
end
