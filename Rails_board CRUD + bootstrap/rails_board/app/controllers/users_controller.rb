class UsersController < ApplicationController

  def login
  end

  def login_session
    user = User.find_by(email: params[:email])

    if user
      if user.password == params[:password]
        session[:user_id] = user.id
        flash[:notice] = "로그인이 성공적으로 되었습니다."
        redirect_to '/'
      else
        flash[:alert] = "바보야 비밀번호가 틀렸어!"
        redirect_to '/users/login'
      end
    else
      flash[:alert] = "아이디가 없잖아 바보야 회원가입부터해"
      redirect_to '/users/signup'
    end
  end

  def logout
    session.clear
    flash[:notice] = "로그아웃 됨! 잘가 ~"
    redirect_to '/'
  end

  def signup
  end

  def register
    User.create(
      email: params[:email],
      password: params[:password]
    )
    redirect_to '/'
  end

end
