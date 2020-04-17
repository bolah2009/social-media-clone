# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_friendship, only: %i[destroy update]

  def create
    friendship = current_user.friendships.build(friendship_params)
    return unless friendship.save

    flash[:success] = 'Friend request sent'
    redirect_to request.referer || root_path
  end

  def destroy
    @friendship&.destroy_friendship
    redirect_to request.referer || root_path
  end

  def update
    return unless @friendship.confirm_friend

    flash[:success] = 'Friend request accepted'
    redirect_to request.referer || root_path
  end

  def pending
    @pending = current_user.pending_friends
  end

  def index; end

  private

  def find_friendship
    @friendship = Friendship.find_by(id: params[:id])
  end

  def friendship_params
    params.require(:friendship).permit(:friend_id)
  end
end
