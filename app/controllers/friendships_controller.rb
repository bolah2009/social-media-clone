# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  def create
    friendship = current_user.friendships.build(friendship_params)
    return unless friendship.save

    flash[:success] = 'Friend request sent'
    redirect_to root_url
  end

  def index; end

  private

  def friendship_params
    params.require(:friendship).permit(:friend_id)
  end
end
