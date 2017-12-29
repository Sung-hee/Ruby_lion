## 멋쟁이사자처럼 프로젝트 실습 16일차

### 오늘은 Atom과 heroku로



### 1. 오늘은 카카오톡 플러스친구를 만들겠습니다 !

>### 1. 우선 프로젝트부터 만들자
>
>```ruby
># 프로젝트 만들기
>$ rails new kakako_bot --skip-bundle 
># 카카오 컨트롤러 만들기
>$ rails g controller kakao keyboard message
>```
>
>- routes.rb 수정하기
>
>```ruby
># config/routes.rb 수정
># get 'kakao/keyboard'를 다음과 같이 바꾸어 줍니다.
>get '/keyboard' => 'kakao#keyboard'
># get 'kakao/message'를 다음과 같이 바꿔줍니다.
>post '/message' => 'kakao#message'
>```
>
>- kakao_controller.rb 수정하기
>
>```ruby
>def message
>  @user_msg = params[:content] # 사용자가 보낸 내용은 content에 담아서 전송
>end
>```
>
>- application_controller.rb CSRF 공격을 막기위한 부분을 주석처리 해줍니다.
>
>```ruby
>class ApplicationController < ActionController::Base
>  # Prevent CSRF attacks by raising an exception.
>  # For APIs, you may want to use :null_session instead.
>  protect_from_forgery with: :exception # 이 부분을 주석처리
>end
>```
>
>- 응답을 하기 위한 기본 문장 API문서를 읽어보자 !
>
>```ruby
>def message
>  @user_msg = params[:content] # 사용자가 보낸 내용은 content에 담아서 전송됩니다.
>  @msg = "기본응답입니다."
>
>  # 메세지를 넣어봅시다.
>  @message = {
>    text: @msg
>    }
>
>  # 자주 사용할 키보드를 만들어 주겠습니다.
>  @basic_keyboard = {
>    :type => "buttons",						
>    buttons: ["선택 1", "선택 2", "선택 3"]
>    }
>
>  # 응답
>  @result = {
>    message: @message,
>    keyboard: @basic_keyboard
>    }
>
>  render json: @result
>end
>```
>
> 
>
>- helpers 이용해서 모듈 사용하기 !
>
>```ruby
># 1. parser.rb 만들어서 Movie와 Animal로 모듈을 나눠주자
>module Parser
>  class Movie
>    def naver
>      url = "http://movie.naver.com/movie/running/current.nhn?view=list&tab=normal&order=reserve"
>      movie_html = HTTParty.get(url)
>      doc = Nokogiri::HTML(movie_html)
>
>      movie_title = Array.new
>      movie_info = Hash.new
>
>      doc.css("ul.lst_detail_t1 dt a").each do |title|
>        movie_title << title.text
>      end
>
>      doc.css("ul.lst_detail_t1 li").each do |movie|
>        # movie_info 안에 movie.css("dl dt.tit a").text 이런 키가 있다.
>        # 쉽게말하자면 "강철비 (키값)" => "{:url, :star}" 이런 구조임!
>        movie_info[movie.css("dl dt.tit a").text] = {
>          :url => movie.css("div.thumb img").attribute('src').to_s,
>          :star => movie.css("dl.info_star span.num").text
>        }
>      end
>
>      sample_movie = movie_title.sample
>      return_text = sample_movie + " " + movie_info[sample_movie][:star]
>      img_url = movie_info[sample_movie][:url]
>
>      return [return_text, img_url]
>    end
>  end
>
>  class Animal
>    def cat
>      return_text = "왜나만 고양이가 없어"
>      # jpg 타입의 이미지만 가져올꺼야.
>      url = "http://thecatapi.com/api/images/get?format=xml&type=jpg"
>      cat_xml = HTTParty.get(url).body
>      doc = Nokogiri::XML(cat_xml)
>      img_url = doc.xpath("//url").text
>
>      return [return_text, img_url]
>    end
>  end
>end
>
>```
>
>- kakao_controller.rb 수정
>
>```ruby
>require 'parser'
>
>class KakaoController < ApplicationController
>  def keyboard
>    home_keyboard = {
>      :type => "buttons",
>      :buttons => ["영화", "메뉴", "고양이", "로또"]
>    }
>    render json: home_keyboard
>  end
>  ...
>    
>  elsif user_message == "고양이"
>  	image = true
>	cat_img = Parser::Animal.new
>    cat_info = cat_img.cat
>    return_text = cat_info[0]
>    img_url = cat_info[1]
>
>  elsif user_message == "영화"
>  	image = true
>    # parser.rb에서 movie 모듈을 사용할꺼야
>    naver_movie = Parser::Movie.new
>    naver_movie_info = naver_movie.naver
>    return_text = naver_movie_info[0]
>    img_url = naver_movie_info[1]
>```
>
>



