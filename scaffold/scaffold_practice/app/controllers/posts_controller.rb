class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all.reverse
  end

  def new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to '/'
    else
      flash[:alert] = "제목과 내용은 필수로 입력해야함"
      redirect_to :back
    end
  end

  def show
  end

  def edit
  end

  def update
    @post.update(post_params)
    # redirect_to "/posts/#{@post.id}"
    redirect_to @post
  end

  def destroy
    @post.destroy

    redirect_to '/'
  end

  private # 클래스 안에서만 쓰일때, MVC 컨트롤러와 상관 없는 곳에만 사용
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    # params으로 들어온 어떠한 값들도 안받을래, 나는 require로 title, content 들어온 값만 받을꺼야
    # 보안적인 측멱에서 사용함. Strong parameter == whitelist == 허락된 정보만 받아라
    def post_params
      params.require(:post).permit(:title, :content)
    end
end
