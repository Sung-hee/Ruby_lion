# httparty와 똑같은 애임 !
# require 'rest-client'
require 'nokogiri'
require 'httparty'
require 'parser'

class KakaoController < ApplicationController
  def keyboard
    home_keyboard = {
      :type => "buttons",
      :buttons => ["영화", "토트넘", "메뉴", "고양이", "로또"]
    }
    render json: home_keyboard
  end

  def message
    # 사용자가 보낸 내용은 content에 담아서 전송
    user_message = params[:content]
    return_text = "임시 텍스트"
    image = false

    puts params[:content]

    if user_message == "로또"
      return_text = (1..45).sample(6).to_s
    elsif user_message == "메뉴"
      return_text = ["20층", "중국집", "순대국밥", "서브웨이", "뚝불"].sample
    elsif user_message == "고양이"
      image = true

      cat_img = Parser::Animal.new
      cat_info = cat_img.cat
      return_text = cat_info[0]
      img_url = cat_info[1]

    elsif user_message == "영화 추천"
      image = true
      # parser.rb에서 movie 모듈을 사용할꺼야
      naver_movie = Parser::Movie.new
      naver_movie_info = naver_movie.naver
      return_text = naver_movie_info[0]
      img_url = naver_movie_info[1]
    else
      return_text = "지금 사용가능한 명령어는 <메뉴>, <로또>, <고양이>, <영화> 입니다."
    end

    home_keyboard = {
      :type => "buttons",
      :buttons => ["영화", "메뉴", "고양이", "로또"]
    }

    return_message_with_img = {
      :message => {
        :text => return_text,
        :photo => {
          :url => img_url,
          :width => 640,
          :height => 480
        }
      },
      :keyboard => home_keyboard
    }
    return_message = {
      :message => {
        :text => return_text
      },
      :keyboard => home_keyboard
    }

    if image
      render json: return_message_with_img
    else
      render json: return_message
    end

  end
end
