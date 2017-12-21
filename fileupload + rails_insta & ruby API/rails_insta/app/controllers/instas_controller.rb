class InstasController < ApplicationController
  before_action :authorize

  def authorize # 로그인 되었는지 판별해라
    redirect_to '/users/login' unless current_user
  end

  def index
    @posts = Post.all.reverse
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
  end

  def create
    Post.create(
      user_id: session[:user_id],
      title: params[:title],
      content: params[:content],
      avatar: params[:avatar]
    )
    redirect_to '/'
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy

    redirect_to '/'
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    post = Post.find(params[:id])

    post.update(
      title: params[:title],
      content: params[:content]
    )
    redirect_to '/'
  end

  def add_comment
    Comment.create(
      content: params[:content],
      post_id: params[:id],
      user_id: current_user.id
    )
    redirect_to :back
  end
end
