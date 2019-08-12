class LikesController < ApplicationController

  def create
    p params
    @like = current_user.likes_given.build(post_id: params[:post_id])
    if @like.save
      redirect_to posts_path
    end
  end

  def destroy
    @like = Like.find_by(id: params[:id])
    if @like
      @like.delete
      redirect_to posts_path
    end
  end

  private

  def like_params
    params.require(:like).permit(:post_id)
  end
end
