class UsersController < ApplicationController
  def index
  end

  def signup
  end

  def register
    @email = params["email"]
    @password = params["password"]

    Userlist.create(
      email: params[:email],
      password: params[:password]
    )
    redirect_to '/users'
  end

  def user_list
    @users = Userlist.all.reverse

  end

  def login
  end

  def login_session
    @message = ""
    puts Userlist.where(email: params[:email])

    if Userlist.where(email: params[:email])

      if Userlist.where(email: params[:email]).first.password == params[:password]
        session[:email] = params[:email]

        redirect_to '/users'
      else
        @message = "비밀번호가 틀렸습니다."
      end
    else
      @message = "해당하는 유저의 정보가 없습니다."
    end
  end

  def logout
    session.clear

    redirect_to '/users'
  end
end
