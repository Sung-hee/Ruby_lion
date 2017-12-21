## 멋쟁이사자처럼 프로젝트 실습 11일차

#### 실습은 Atom으로 !



### 1. 오늘도 복습으로 시작

>#### insta 만들기!
>
>```ruby
># Instagram Clone 
># 심심해서 만들었던 rails_insta를 가지고 실습을 이어나가겠습니다 !
>
># 1. User model & Authentication(login)
>
># 2. Post model 
>
># 3. Comment
>
># 4. User : Post = 1 : N
>
># 5. Post : Comment = 1 : N
>
># 6. File Upload(Image)
>
># 7. Like(Heart)
>```
>
>1. 소소한 팁!
>
>```ubuntu
>rails g model Post title content:text user_id:integer
> - 변수명:타입 으로 default String 타입에서 다른 타입으로 변경할 수 있음 !
>rake routes 
> - 현재 가지고 있는 routes를 보여줌 !
>```
>
>2. link_to 헬퍼 사용법 (링크 헬퍼)
>
>```erb
><li class="nav-item">
>	<!-- <%= link_to "회원가입", "/users/signup" %> -->
>	<a class="nav-link" href="/users/signup">회원가입</a>
></li>
><li class="nav-item">
>	<!-- <%= link_to "로그인", "/users/login" %> -->
>	<a class="nav-link" href="/users/login">로그인</a>
></li>
><li class="nav-item">
>	<!-- <%= link_to "로그아웃", "/users/logout" %> -->
>	<a class="nav-link" href="/users/logout">로그아웃</a>
></li>
>```
>
>3. form_tag와 input_tag (form, input  헬퍼)
>
>```erb
><form action="/instas/create">
>  <input type="text" name="title">
>  <input type="text" name="content">
>  <input type="submit">
></form>
><!-- 아래와 위 코드는 똑같은 기능을 한다. -->
><!-- 이와 같이 코드를 작성하면 post 형식으로 요청을 보내게 된다 ! -->
><!-- 그러므로 routes에서 get 'posts/create' -> post 'posts/create'로 변경해줘야 한다 !
><%= form_tag("/instas/create") do %>
>  <%= text_field_tag("title") %>
>  <%= text_field_tag("content") %>
>  <%= submit_tag("확인") %>
><% end %>
>```
>
>4. 마지막으로 application_controller.rb 에서 protect_from_forgery with: :exception 를 주석처리 해준다. 
>
>- **protect_from_forgery with: :exception 이거는 rails에서 CSRF 해킹 방법을 막아주는 기능!** 
>
>
>- 근데 이거는 안좋은 방법이다 ! 되게 위험한 방법임 ! 해킹 당하기 쉬움 ! 
>- 그치만 지금은 일단 사용하자 ! 나중에 헬퍼를 이용하여 다른 방법을 사용하겠음 !
>
>5. url로 게시글을 삭제할 수 있다 ! 그럼 어떻게 해야 url로 삭제하는걸 막을 수 있을까?!
>
>```ruby
># 우선적으로 routes.rb get -> post로 변경한다.
>get 'instas/destroy/:id' => 'instas#destroy'  
>	=> post 'instas/destroy/:id' => 'instas#destroy' 
>```
>
>```erb
><!-- 이후 link_to 헬퍼를 통해서 요청을 post로 바꿔준다 ! -->
><%= link_to "삭제", "/instas/destroy/#{@post.id}", data: {method: "post", confirm: "진짜 삭제 하실거에요?"}%>
><!-- data: 는 두개의 인자를 사용할때 씀 ! 그리고 confirm 은 팝업창을 띄워서 삭제할지 다시 한번 알려줌 -->
>```
>
>6. **restful** ? 진짜 사람이 말하는 것처럼 url 을 바꾸면 안될까? 그럼 바꿔보자 !
>
>```ruby
>  resources: belongs # 이놈을 입력하고 3000/rails/info/routes에서 확인하면
>  # 이런식으로 url이 나옴 ! url을 규칙성 있게 만들고 구분을 지어준다 !
>  # belong_path	GET	/belongs/:id(.:format)	belongs#show
>  #             PATCH	/belongs/:id(.:format)	belongs#update
>  #             PUT	/belongs/:id(.:format)	belongs#update
>  #             DELETE	/belongs/:id(.:format)	belongs#destroy
>```
>
>

### 2. 파일 업로드

>1. 파일 업로드를 도와주는 잼을 다운받자 ! gem carrierwave
>
>```ruby
># Gemfile 에다가 아래의 코드를 추가하면 끝 ! 그리고 bundle install을 해주자 !
># https://github.com/carrierwaveuploader/carrierwave 에서 확인하자
>gem 'carrierwave', '~> 1.0'
>
># ubuntu 에서 해줄 것들 !
>bundle install
>rails generate uploader Avatar
>rails g migration add_avatar_to_posts avatar:string
>rake db:migrate
>
># uploaders -> avatar_uploader.rb 에 추가
>class User < ActiveRecord::Base
>  mount_uploader :avatar, AvatarUploader
>end
>```
>
>2. new.html.erb 수정
>
>```erb
><!-- 사진 올리기 enctype 추가해줘야함 !-->
><form action="/instas/create" method="post" enctype="multipart/form-data">
> 
><div class="form-group">
>	<label for="exampleInputPassword1">사진업로드</label>
>	<input type="file" class="form-control" name="avatar">
></div>
>```
>
>3. show.html.erb 수정
>
>```erb
><!-- 사진 올린거 보여주기 -->
><p class="card-text"><img src="<%= @post.avatar %>"</p>
>```
>
> 
>
>

### 3. 쿠키와 세션

> 쿠키는 자기 자신이 가지고 있고
>
> - 키워드, 검색어 등등
>
> 세션은 서버에 넣어주는 것
>
> - 세션은 해쉬 구조
> - 중요한 것들을 넣어서 보관함 ex) 개인정보 
>
> **번외**
>
> **Validates[:user.email]  를 통해서 회원가입 시 중복을 막을 수 있음 !**



### 4. 번외편

>### 1] ruby로 API 가지고 놀기
>
>- ruby 2.4.2 버전 설치하기 !
>
>```ubuntu
>$ rbenv install 2.4.2
>
>$ mkdir ruby_api
>$ rbenv local 2.4.2 
>-> ruby_api 폴더에서만 ruby 2.4.2 버전을 사용하겠다
>```
>
>- https://rubygems.org/ 잼들을 모아둔 곳
>- bundler 란 ?
>  - 음식점에서 여러명의  주문을 주문서에 작성하고 한번에 주문하는 역할을 해주는 것!
>  - 또한 체이닝 되어있는 잼들을 관리하여 충돌을 막아줌 !
>
>```ubuntu
>$ touch Gemfile
>
>#Gemfile 안에다 작성 !
>#source 'https://rubygems.org'
># Enhanced IRB
>gem 'pry'
># 이쁘게 찍자
>gem 'awesome_print'
>
>$ bundle
># 완료되면 gem들을 사용 가능함 !
>```
>
>1. 로또 당첨확인
>
>```ruby
># 오픈을 확장하여 uri까지 오픈할 수 있게 도와줌
>require 'open-uri'
>require 'json'
>
>my_numbers = [1..45].to_a.sample(6)
># my_numbers = [*1..45].sample(6) 두개는 같은 문법
>
>url = 'http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo='
>page = open(url).read
>info = JSON.parse(page)
>
># 1. 현재 info hash에 있는 값을 잘 해서 아래에 넣는다.
>lucky_numbers = []
>
>info.each do |key, value|
>   lucky_numbers << value if key.include?('drwtNo')
>   lucky_numbers.sort!
>   # if key.include?('drwtNo')
>   #    lucky_numbers = value
>   # end
>end
>
>bouns_number = info['bnusNo']
>
>match_numbers = lucky_numbers & my_numbers
>match_count = match_numbers.count
>
>result =
>   case [match_count, my_numbers.include?(bouns_number)]
>      when [6, false] then '1등'
>      when [5, true]  then '2등'
>      when [5, false] then '3등'
>      when [4, false] then '4등'
>      when [3, false] then '5등'
>      else '꽝'
>   end
>
>puts result
>```
>
>2. 주식정보 받아오기
>
>```ruby
># 주식정보 받아오기
>gem 'stock_quote'
>
>require 'stock_quote'
>
>companies = ['AAPL', 'FB', 'TSLA', 'GOOGL', 'AMZN']
>
>companies.each do |company|
>  stock = StockQuote::Stock.quote(company)
>
>	company.chomp!
>end
>
>########################################################################
>require 'stock_quote'
>
>DATA.each do |company|
>  stock = StockQuote::Stock.quote(company)
>
>  puts stock.name
>  puts stock.l
>end
>
># 파일이 끝났다라고 인식함 END 밑으로는 루비코드가 아니라고 인식함
># 아래는 전부 DATA 처리 / END 밑으로 전부 DATA라는 이름으로 저장됨
>__END__
>AAPL
>FB
>TSLA
>GOOGL
>AMZN
># 하지만 이렇게 하면 뒤에 '\n'이 붙게 되버린다 !
># 그러므로 .chomp를 이용하여 '\n'을 다 없애버리자 !
>```
>
>3. 환율 계산하기
>
>```ruby
># 환율 변환용 은행
>gem 'eu_central_bank'
>
># 코드
>require 'eu_central_bank'
>
>bank = EuCentralBank.new
>
># from = 'USD'
># to = 'KRW'
>#
># result = bank.exchange(from, to)
>
>def exchange(from)
>  # 실시간으로 패치에서 정보를 받아옴
>  bank.update_rates
>
>  bank.exchange(100, from, 'KRW')
>end
>
>puts "$1 => #{exchange('USD')}원"
>
>```
>
>4. 날씨 정보 받아오기
>
>```ruby
>require 'forecast_io'
>
>ForecastIO.configure do |configuration|
>    configuration.api_key = 'b08b5d7f3d6a0704568c7c0e69a745f0'
>end
>forecast = ForecastIO.forecast(37.501554, 127.039703)
>f = forecast.currently
>
>def f_to_c(f)
>    f = f.to_f
>    ((f - 32) * 5 / 9 ).round(2)
>end
>
>puts f.temperature
>puts f.summary
>puts f_to_c f.temperature
>```
>
>5. 위도 경도 구하기
>
>```ruby
>require 'geocoder'
>
>print '어디가 궁금하세요? :'
>input = gets.chomp
>loCord = Geocoder.coordinates('input')
>p loCord
>```
>
>6. 날씨 정보와 위도 경도 합치기
>
>```ruby
>require 'geocoder'
>require 'forecast_io'
>
>ForecastIO.configure do |configuration|
>    configuration.api_key = 'b08b5d7f3d6a0704568c7c0e69a745f0'
>end
>
>def f_to_c(f)
>    f = f.to_f
>    ((f - 32) * 5 / 9 ).round(2)
>end
>
>print '어디가 궁금하세요? :'
>input = gets.chomp
>
>loCord = Geocoder.coordinates(input)
>forecast = ForecastIO.forecast(loCord.first, loCord.last)
>f = forecast.currently
>
>puts "#{input}의 현재 날씨는 #{f.summary} 며, 섭씨 #{f_to_c f.temperature}도 입니다."
>```
>
>

