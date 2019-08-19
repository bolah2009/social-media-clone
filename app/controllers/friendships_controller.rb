# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_friendship, only: %i[destroy update]

  def create
    friendship = current_user.friendships.build(friendship_params)
    return unless friendship.save

    flash[:success] = 'Friend request sent'
    redirect_to request.referrer
  end

  def destroy
    @friendship.destroy_mutual if friendship_params[:type] == 'unfriend'
    @friendship&.destroy
    redirect_to request.referrer
  end

  def update
    return unless @friendship.confirm_friend

    flash[:success] = 'Friend request accepted'
    redirect_to request.referrer
  end

  def index; end

  private

  def find_friendship
    @friendship = Friendship.find_by(id: friendship_params[:friendship_id])
  end

  def friendship_params
    params.require(:friendship).permit(:friend_id, :friendship_id, :type)
  end
end
