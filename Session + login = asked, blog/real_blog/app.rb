require 'rubygems'
require 'sinatra'
require 'data_mapper' # metagem, requires common plugins too.
require 'sinatra/reloader'
require './model.rb' # 데이터베이스 관련 파일

# 이 코드를 입력하면 커맨드창에서 -o 0.0.0.0 을 입력안해도 됨 !
set :bind, '0.0.0.0'

enable :sessions # 내가 앱에서 세션을 활용할거얌

get '/' do
  # 가지고 있는 Post를 보여줌
  @posts = Post.all.reverse
  # reverse이용해서 최신글이 맨 위에 올라오도록 만들자.

  erb :index
end

get '/create' do
  # DB에 저장하기 위해서 create에 저장 폼을 만듬
  Post.create(
    :title => params["title"],
    :body => params["content"]
  )

  # 홈 페이지로 보내기
  redirect to '/'
end

get '/signup' do
  erb :signup
end

get '/register' do
  # DB에 저장하기 위해서 user 저장 폼을 만듬
  User.create(
    :email => params["email"],
    :password => params["password"]
  )

  # 홈 페이지로 보내기
  redirect to '/'
end

get '/admin' do
  # 모든 유저를 불러와
  # admin.erb에서 모든 유저의 정보를 보여준다.
  @users = User.all.reverse

  erb :admin
end
# login 컨트롤
get '/login' do
  erb :login
end

get '/login_session' do
  @message = ""
  # 로그인하려고 하는 유저가 DB에 저장되어있는지 체크
  if User.first(:email => params["email"])
    # 일치하는 유저 정보가 있다면
    # 패스워드가 일치하는지 검사
    if User.first(:email => params["email"]).password == params["password"]
      # 패스워드 또한 일치한다면
      session[:email] = params["email"]
      # 로그인이 완료되었으니 메인 홈으로 이동
      redirect to '/'
    else
      # 비밀번호가 틀렸을 때
      @message = "비밀번호가 틀렸습니다."
    end
  else
    # 유저의 정보가 없을 때
    @message = "해당하는 유저의 정보가 없습니다."
  end
end
# logout 컨트롤
get '/logout' do
  session.clear

  redirect to '/'
end
