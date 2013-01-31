class PostsController < ApplicationController
  meta_tags_from :post

  def index
    set_meta_tag :title, "Test in action"
    set_meta_tag :description, "Test in action"
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def filter
    @posts = Post.where('title LIKE ?', "%#{ params[:tag] }%")
  end
end
