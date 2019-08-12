class CommentsController < ApplicationController

  def new

  end

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      redirect_to posts_path
    else

    end
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
