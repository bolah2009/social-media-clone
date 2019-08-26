# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :post_id, only: %i[destroy edit update]

  def index
    @posts = current_user.feed
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = 'Post was successfully created'
      redirect_to root_url
    else
      @posts = current_user.feed
      render 'index'
    end
  end

  def edit; end

  def update
    if @post.update_attributes(post_params)
      flash[:success] = 'Post updated successfully'
      redirect_to root_path
    else
      flash.now[:warning] = 'Somenthing went wrong, post not edited'
      render 'edit'
    end
  end

  def destroy
    if @post
      @post.delete
      flash[:success] = 'Post deleted successfully'
      redirect_to root_url
    else
      flash[:warning] = "Coundn't detele the post"
      @posts = current_user.feed
      render 'index'
    end
  end

  private

  def post_id
    @post = Post.find_by(id: params[:id])
  end

  def post_params
    params.require(:post).permit(:content)
  end
end
