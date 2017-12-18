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
end
