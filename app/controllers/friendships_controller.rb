# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :friendship_request, only: :destroy

  def create
    friendship = current_user.friendships.build(friendship_params)
    return unless friendship.save

    flash[:success] = 'Friend request sent'
    redirect_to request.referrer
  end

  def destroy
    @friendship&.destroy
    redirect_to request.referrer
  end

  def update
    friendship = current_user.pending_requests
      .where('user_id = ?', friendship_params[:friend_id]).first
    p friendship
    return unless friendship.confirm_friend

    flash[:success] = 'Friend request accepted'
    redirect_to request.referrer
  end

  def index; end

  private

  def friendship_request
    case friendship_params[:type]
    when 'pending'
      @friendship = current_user.pending_requests
        .where('user_id =  ?', friendship_params[:friend_id]).first
    when 'sent'
      @friendship = current_user.sent_requests
        .where('friend_id = ?', friendship_params[:friend_id]).first
    when 'unfriend'
      @friendship = current_user.friendships
        .where('friend_id = ?', friendship_params[:friend_id]).first
      @friendship.unfriend
    end
    @friendship
  end

  def unfriend; end

  def friendship_params
    params.require(:friendship).permit(:friend_id, :type)
  end
end
