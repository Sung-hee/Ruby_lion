class UsersController < ApplicationController
  def signup
    # 폼으로 가입정보를 받아 /register
  end

  def register
    User.create(
      email: params[:email],
      password: params[:password]
    )
    redirect_to '/'
  end

  def login
    # 폼으로 로그인 정보를 받아 /login_session으로 보낸다

  end

  def login_session
    user = User.find_by(email: params[:email])
    if user
      if user.password == params[:password]
        session[:user_id] = user.id
        redirect_to '/'
      else
        puts "비번이 틀렸소"
        redirect_to '/users/login'
      end
    else
      puts "회원가입을 하시오"
      redirect_to '/users/signup'
    end
  end

  def logout
    session.clear
    redirect_to '/'
  end
end
