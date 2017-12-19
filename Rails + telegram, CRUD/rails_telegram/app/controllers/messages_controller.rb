class MessagesController < ApplicationController
  # 필터링
  before_action :authorize
    # 모든 컨트롤러가 발동되기 이전에
    # 유저가 접속되어 있는지 확인한다.

  def authorize # 로그인 되었는지 판별해라
    redirect_to '/users/login' unless current_user
  end

  def index
    @messages = Message.all.reverse
  end

  def send_msg
    Message.create(
      user_id: session[:user_id],
      content: params[:msg]
    )

    url = "https://api.telegram.org/bot"
    token = Rails.application.secrets.telegram_token

    res = HTTParty.get("#{url}#{token}/getUpdates")
    hash = JSON.parse(res.body)

    chat_id = hash["result"][0]["message"]["chat"]["id"]

    text = URI.encode("#{current_user.email}: " + params[:msg])
    HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{text}")

    redirect_to '/'
  end
end
