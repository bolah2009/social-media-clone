# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      flash[:success] = 'Comment successfully created'
    else
      flash[:warning] = 'Comment not created'
    end
    redirect_to posts_path
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    return unless @comment

    @comment.delete
    flash[:success] = 'Your comment was deleted'
    redirect_to posts_path
  end

  private

  def comment_params
    params.require(:comment).permit(:post_id, :content)
  end
end
