class UsersController < ApplicationController
  def signup
  end

  def register
    User.create(
      email: params[:email],
      password: params[:password],
    )
    redirect_to '/'
  end

  def login
  end

  def login_session
    user = User.find_by(email: params[:email])
    if user
      if user.password == params[:password]
        session[:user_id] = user.id
        flash[:notice] = "로그인이 되었습니다."
        redirect_to '/'
      else
        flash[:alert] = "비밀번호가 틀렸습니다."
        redirect_to '/users/login'
      end
    else
      flash[:alert] = "아이디가 없습니다. 회원가입하세요 !"
      redirect_to '/users/signup'
    end
  end

  def logout
    session.clear
    flash[:notice] = "로그아웃이 되었습니다."
    redirect_to '/'
  end
end
