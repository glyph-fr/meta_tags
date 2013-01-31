class PostsController < ApplicationController
  meta_tags_from :post

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def filter
    @post.where('title LIKE ?', "%#{ params[:tag] }%")
  end
end
