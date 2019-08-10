class CommentController < ApplicationController

  def new
    @comment = current_user.build
  end

  def create
    @comment = current_user.build(params[post_id])
    if @comment.save
      
    else

    end
  end
end
