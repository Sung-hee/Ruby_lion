## 멋쟁이사자처럼 프로젝트 실습 8일차

### 1. 오늘은 먼저 다음 Webtoon을 긁어오면서 실습을 진행합니다 !

> #### 스크래핑 및 크롤링을 이용해서 전시간보다 조금 더 편하게 긁어오는 방법에 대해서 연습합니다 !
>
> 오늘은 크롬의 개발자도구에서 Network 탭에서 놀겠습니다 !
>
> #### 1. Network 탭
>
> 우리가 원하는 데이터는 Network 탭 - XHR에 저장되어 있다 !  XHR에는 대부분 json파일들로 되어있음 !
>
> tue?timeStamp=숫자 파일을 클릭해서 보면 이미지 및 데이터 정보들이 저장되어 있다 !
>
> 그러면 우리는 그 파일의 Request URL을 이용하여 크롤링하면 된다 !
>
> [수요일 웹툰의 Request URL]
>
> http://webtoon.daum.net/data/pc/webtoon/list_serialized/tue?timeStamp=1513559333272
>
> list_serialized/까지는 똑같지만 mon, tue, thu 등 요일별로 글자가 다르다 !
>
> #### 2. 그럼 이제 실습을 진행 함 !
>
> - 다음웹툰 볼래용 
> - app.rb
>
> ```ruby
> get '/today' do
>   # 다음 웹툰 크롤링하기
>   # => 우리가 긁어와야할 url 완성본 -> ex) http://webtoon.daum.net/data/pc/webtoon/list_serialized/fri?timeStamp=1513559333272
>   # 1. url을 만든다.
>   # => 요일 url 만들기
>   week =  DateTime.now.strftime("%a").downcase #우리는 요일을 string형식의 세글자로 받겠다 ! 그리고 그 값들을 소문자로 저장하겠다 !
>   # => 현재 시간을 integer로 변환 ex) t.to_i #=> 730522800
>   time = Time.now.to_i
>   url = "http://webtoon.daum.net/data/pc/webtoon/list_serialized/#{week}?timeStamp=#{time}"
>
>   puts url
>
>   # 2. 해당 url에 요청을 보내고 데이터를 받는다.
>   response = HTTParty.get(url)
>   # 3. JSON형식으로 날아온 데이터를 Hash형식으로 바꾼다.
>   doc = JSON.parse(response.body)
>
>   puts doc.class
>   # 4. key를 이용해서 원하는 데이터만 수집한다.
>   # => 원하는 데이터: 제목, 이미지, 웹툰 링크, 소개, 평점
>   # => 평점: averageScore
>   # => 제목: title
>   # => 소개: introduction
>   # => 이미지: appThumbnailImage["url"]
>   # => 링크: "http://webtoon.daum.net/webtoon/view/#{nickname}"
>
>   #doc["data"]를 돌면서 하나씩 뽑을꺼야!
>   @webtoons = Array.new
>
>   doc["data"].each do |webtoon|
>     toon = {
>         title: webtoon["title"],
>         desc: webtoon["introduction"],
>         score: webtoon["averageScore"].round(2),
>         img_url: webtoon["appThumbnailImage"]["url"],
>         url: "http://webtoon.daum.net/webtoon/view/#{webtoon["nickname"]}"
>     }
>     puts toon
>     # 5. view에서 보여주기 위해 @webtoons라는 변수에 담는다.
>     @webtoons << toon
>
>     puts @webtoons
>   end
>
>   erb :webtoon_list
> end
> ```
>
> - day.erb
>
> ```erb
> <!DOCTYPE html>
> <html>
>   <head>
>     <meta charset="utf-8">
>     <title>오늘의 다음웹툰</title>
>   </head>
>   <body>
>     <a href="/">홈으로</a>
>     <h1><%=params[:day]%> 웹툰</h1>
>     <table>
>       <thead>
>         <tr>
>           <th>이미지</th>
>           <th>제목</th>
>           <th>소개</th>
>           <th>평점</th>
>           <th>링크</th>
>         </tr>
>       </thead>
>       <tbody>
>         <% @webtoons.each do |webtoon| %>
>         <tr>
>           <td><img width="100" src="<%= webtoon[:img_url] %>" alt="<%= webtoon[:title] %>"></td>
>           <td><%= webtoon[:title] %></td>
>           <td><%= webtoon[:desc] %></td>
>           <td><%= webtoon[:score] %></td>
>           <td><a href="<%= webtoon[:url] %>" target="_blank">보러가기</a></td>
>         </tr>
>         <% end %>
>       </tbody>
>     </table>
>   </body>
> </html>
> ```
>
> 



### 2. Ruby on Rails

>#### Rails
>
>1. What is Rails?
>
>   **1]우리의 목표 ! 우리는 Web Service를 만든다 !** 
>
>   **2] 프레임 워크?**
>
>   - 기본적인 구조나 필요한 코드들은 **알아서 제공**해줄게, 넌 그냥 **좋은 웹 서비스**를 만드는거에 집중해 !
>
>   **3] MVC ?**
>
>   ![ruby on rails mvc에 대한 이미지 검색결과](http://blog.ifuturz.com/wp-content/uploads/2013/03/railsmvc.png)
>
>2.  Rails 설치방법
>
>```ubuntu
> gem install rails -v 4.2.9
>```
>
>3. Rails 실행방법
>
>```ubuntu
>rails new 폴더이름
>
>이후 Atom으로 폴더를 연다 !
>그리고 app 폴더가 app.rb로 생각하면 편하다 ! 또한 안에 보면 views 폴더, layout 폴더가 있다.
>app폴더에는 MVC 폴더들이 있따.
>
>번들이란것을 스킵하여 만들겠다 !
>rails new 폴더이름 --skip-bundle
>```
>
>4.  컨트롤러 및 모델 생성 방법
>
>```ubuntu
>1. rails generate controller [컨트롤러이름]
>
>2. app -> controllers -> concerns -> home_controller.rb 에서 
>  def index
>  end
>  추가해주기 !
>3. app -> views -> home에 index.erb 만들고 작성 !
>4. routes. rb get '/' => 'home#index' 작성
>######
>rails g controller [컨트롤러이름 (복수형)] 
>컨트롤러의 이름은 복수형으로 s 을 붙여서 만드는것이 rails의 네이밍룰 !
>
>rails g model [모델이름 (단수)]
>rake db:migrate 
>rails console => pry 와 같은 놈
>```
>
>5.  서버 돌리기
>
>```ubuntu
>rails server -b 0.0.0.0
>
>-----------------------------
>매번 -b 0.0.0.0 하기 귀찮으니까 !
>1. cd ~ 홈 디렉터리로 이동 -> vi .bashrc -> 맨 밑에서 알파뱃 'o' 입력
>2. alias rs="rails s -b 0.0.0.0" 입력 후 esc
>3. :w 입력하여 저장 // :q 종료하기
>4. source ~/.bashrc로 프로그램 실행
>5. 이후 rs 로 서버 실행시키면 됨 !
>```
>
>6. gem 추가하기
>
>```Gemfile
>Gemfile에서 
>group :development, :test do 이거는 개발환경과 테스트 환경에서 추가
>group :development do 이거는 개발환경에서만 추가
>
>우리는 일단 group :development do
>	gem 'rails_db'
>end
>
>그리고 커맨드창에서 bundle install 
>```
>
>7. db 관리하기
>
>```chrome
>테스트 환경에서 DB 관리하기
>http://localhost:3000/rails/db
>여기서 추가, 삭제도 가능하다 !
>```
>
>
>
>#### 2. rails 연습하기
>
>```ruby
># 1. lotto
># => 랜덤 로또 번호를 출력해주는 액션을 만드세요
># => get '/lotto' => 'home#lotto'
>
># 2. lunch
># => 랜덤 네뉴를 출력해주는 액션ㅇ르 만드세요
># => get '/lunch' => 'home#lunch'
>
># 3. /search
># => fake naver search를 해주는 액션을 만드세요
># => get '/search' => 'home#search'
># => search.erb -> 검색어를 받아 네이버 검색 결과를 보여주는 form을 만들어 준다.
>```
>
>- routes.rb
>
>```ruby
>  get '/' => 'home#index'
>  get '/hello/:name' => 'home#hello'
>  get '/lotto' => 'home#lotto'
>  get '/lunch' => 'home#lunch'
>  get '/search' => 'home#search'
>```
>
>- home_controller.rb
>
>```ruby
>class HomeController < ApplicationController
>    def index
>    end
>
>    def hello
>      @name = params[:name]
>    end
>
>    def lotto
>      numbers = (1..45).to_a
>
>      @lotto = numbers.sample(6)
>    end
>
>    def lunch
>      menu = ["칼국수", "뚝불", "김치찌개", "순대국"]
>
>      @lunch = menu.sample
>    end
>
>    def search
>
>    end
>
>end
>```
>
>- users 만들기
>
>```ruby
># 1. User
># => rails g controller users
># => rails g model user
># => routes
># => get '/signup' => 'users#signup' 회원가입 <form>으로 정보 받아서 /register로 넘겨준다 (email, password)
># => get '/register' => 'users#register' # 날아온 정보를 User DB에 저장한다
># => get '/user_list' => 'users#list' 모든 유저의 정보를 보여준다.
>```