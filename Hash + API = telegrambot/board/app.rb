require 'rubygems'
require 'sinatra'
require 'data_mapper' # metagem, requires common plugins too.
require 'sinatra/reloader'
require './model.rb' # 데이터베이스 관련 파일(model)

# 이 코드를 입력하면 커맨드창에서 -o 0.0.0.0 을 입력안해도 됨 !
set :bind, '0.0.0.0'

enable :sessions # 내가 앱에서 세션을 활용할거얌

# before가 해주는 것은
# get이 실행되기 전에 한번씩 before를 실행해줌
# 순서를 보게 되면
# before do
#   # 로그인 함수 실행
#   check_login
# end

get '/' do
  @list = Post.all.reverse

  erb :index
end

get '/new' do
  erb :new
end

get '/create' do
  Post.create(
    # :title => params["title"],
    # :content => params["content"],
    # 아래와 위는 동일한 코드이다.
    title: params["title"],
    content: params["content"],
  )

  redirect to '/'
end

get '/signup' do
  erb :signup
end

get '/register' do
  User.create(
    # :email => params["email"],
    # :password => params["password"]
    email: params["email"],
    password: params["password"]
  )

  redirect to '/'
end

get '/login' do
  erb :login
end

get '/login_session' do
  @message = ""

  # if User.first(:email => params["email"])
  #   if User.first(:email => params["email"]).password == params["password"]
  # 이것도 동일한 코드이다.
  if User.first(email: params["email"])
    if User.first(email: params["email"]).password == params["password"]
      session[:email] = params["email"]

      redirect to '/'
    else
      @message = "비밀번호가 틀렸습니다."
    end
  else
    @message = "해당하는 유저의 이메일이 없습니다."
  end
end

get '/logout' do
  session.clear

  redirect to '/'
end

get '/edit/:id' do
  # 수정하기 위해선
  # 수정하고 싶은 정보가 edit에 넘어와야 한다 !
  # 그러니 여기에서도 variable routing을 이용한다.
  @post = Post.get(params[:id])

  erb :edit
end

get '/update/:id' do
  post = Post.get(params[:id])
  post.update(
    # :title => params["title"], 이렇게 해두 됨ㅋ
    :title => params[:title],
    :content => params[:content]
  )

  redirect to '/'
end

get '/destroy/:id' do
  # 1번 글을 지우게 될거면
  # '/destroy/1...5'
  post = Post.get(params[:id])
  post.destroy

  redirect to '/'
end

def check_login
  # 만약 ~ 이지 않으면
  unless session[:email]
    redirect to '/'
  end
end
