# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!

  def new; end

  def create
    @comment = current_user.comments.build(comment_params)
    redirect_to posts_path if @comment.save
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    if @comment
      @comment.delete
      redirect_to posts_path
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:post_id, :content)
  end
end
