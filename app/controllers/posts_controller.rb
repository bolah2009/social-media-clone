# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!

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
      @posts = Post.all
      render 'index'
    end
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
