require 'rubygems'
require 'sinatra'
require 'data_mapper' # metagem, requires common plugins too.
require 'sinatra/reloader'
require './model.rb' # 데이터베이스 관련 파일(model)

# 이 코드를 입력하면 커맨드창에서 -o 0.0.0.0 을 입력안해도 됨 !
set :bind, '0.0.0.0'

enable :sessions # 내가 앱에서 세션을 활용할거얌

get '/' do
  @q_list = Question.all.reverse

  erb :index
end

get '/asked' do
  Question.create(
    :name => params["id"],
    :question => params["question"]
  )

  redirect to '/'
end

get '/signup' do

  erb :signup
end

get '/register' do
  User.create(
    :email => params["email"],
    :password => params["password"]
  )

  redirect to '/'
end

get '/admin' do
  @user_list = User.all

  erb :admin
end

get '/login' do
  erb :login
end

get '/login_session' do
  @message = ""
  # 로그인 하려고 하는 사람이 우리 회원인지 검사
  if User.first(:email => params["email"])
    # 일치하는 email이 있다면
    # 패스워드가 일치하는지 검사
    if User.first(:email => params["email"]).password == params["password"]
      #패스워드 또한 일치하면 로그인
      session[:email] = params["email"]
      @message = "로그인이 되었습니다."
      redirect to '/'
      # session = {}
      # {:emial => "params["email"]"}
    else
      @message = "비번이 틀렸습니다."
    end
  else
    @message = "해당하는 이메일의 유저가 없습니다."
  end
end

get '/logout' do
  session.clear

  redirect to '/'
end
