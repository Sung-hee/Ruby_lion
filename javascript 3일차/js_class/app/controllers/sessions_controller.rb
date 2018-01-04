class SessionsController < ApplicationController
  # 회원가입 화면
  def signup
  end

  # 회원가입 액션
  def user_signup
    user = User.new(
      email: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )

    if user.save
      redirect_to '/signin', notice: "회원가입 완료!"
    else
      redirect_to '/signup', notice: "잘못된 비밀번호 입니다."
    end
  end

  def check_email
    @email = params[:email]
    @tmp = User.find_by(email: params[:email]).nil?
  end

  # 로그인 화면
  def signin
  end

  # 로그인 액션
  def user_signin
    user = User.find_by(email: params[:email])

    # authenticate는 bcrypt 때문에 사용할 수 있는 메소드
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to '/', notice: "로그인에 성공했습니다."
    else
      redirect_to '/signin', notice: "이메일이 없거나, 비밀번호가 틀렸습니다."
    end
  end

  # 로그아웃
  def signout
    # delete는 clear와 하는 역할은 같다 ! 여기서는 delete를 이용해 id만 날리겠음 !
    session.delete(:user_id)
    redirect_to '/', notice: "로그아웃 성공!"
  end
end
