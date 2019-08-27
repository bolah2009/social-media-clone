# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @like = current_user.likes_given.build(post_id: params[:post_id])
    redirect_to posts_path if @like.save
  end

  def destroy
    @like = Like.find_by(id: params[:id])
    return unless @like

    @like.delete
    redirect_to posts_path
  end
end
