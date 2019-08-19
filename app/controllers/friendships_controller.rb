# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  def create
    friendship = current_user.friendships.build(friendship_params)
    return unless friendship.save

    flash[:success] = 'Friend request sent'
    redirect_to request.referrer
  end

  def destroy
    p friendship_params
    operation = friendship_params[:type]
    case operation
    when 'pending'
      friendship = current_user.pending_requests
        .where('user_id =  ?', friendship_params[:friend_id])
    when 'sent'
      friendship = current_user.sent_requests
        .where('friend_id = ?', friendship_params[:friend_id])
    end
    friendship.first&.destroy
    redirect_to request.referrer
  end

  def update
    render 'here'
  end

  def index; end

  private

  def friendship_params
    params.require(:friendship).permit(:friend_id, :type)
  end
end
