## 멋쟁이사자처럼 프로젝트 실습 14일차

#### 오늘도 실습은 Atom으로



### 1. 오늘은 watcha를 만들면서 시작하겠습니다 !

>### 1. 목표
>
>```ruby
># Watcha clone app
># fake 왓챠 based on rails
>
># 1. 영화정보(Movie -> 직접)
># => model : Movie
># => controller : movies
># => 관리자 : CRUD
># => 로그인 된 유저 : 점수를 줄 수 있다, 댓글도 달 수 있다.
># => 댓글(Comment)
>
># 2. 게시판(Post -> Scaffold)
># => 로그인 안된 유저 : R
># => 로그인 된 유저 : CRUD(본인의 글)
># => 관리자는 깡패라서 CRUD(모든 글)
># => 댓글(Comment)
>
># 3. 유저(User -> Devise)
># => signup, login, ... (o)
># => 관리자 / 일반유저 (o)
>```
>
>### 2. 만들기 시작
>
> ```ruby
># 1. watchar 프로젝트 만들기
># => $ rails new watcha --skip-bundle
>
># 2. Gemfile 추가하기
># => gem 'devise'
># => gem 'rails_db'
># => gem 'awesome_print'
># => gem 'pry-rails'
># => $ bundle install
>
># 3. devise 만들기
># => $ rails g devise:install
># 4. config 폴더 -> environments폴더 -> development.rb에 추가
># => config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
># 5. $ rails g devise User
># => db에 t.boolean :is_admin?, null: false, default: false 추가
># => $ rake db:migrate
>
># 6. home 만들기
># => $ rails g controller home index
># 7. login, logout 만들기
># 8. view 만들기
># => $ rails g devise:views
># 9. i18n 사용하기
># => 아래 i18n 사용하기 참고
># 10. i18n views 사용하기
># => $ rails g devise:i18n:views 하고 모두 오버라이팅하기
># => 이거까지 해주면 모든게 다 영어 -> 한글로 바뀜 ! 자동으로 !
># 11. 게시판 만들기
># => $ rails g scaffold Post title content:text user_id:integer
># 12. 1 : N 만들기
># => User has_many :posts
># => Post belongs_to :user
># 13. 로그인 후에만 게시판 기능 사용할 수 있게 만들기
># post_controller.rb에 추가하기 
>before_action :authenticate_user!, except: [:index]
># except는 only와 반대로 index만 제외하고 before_action을 실행시킴.
> ```
>
>- login, logout 만들기
>
>```erb
><p id="notice"><%= flash[:notice] %></p>
><p id="alert"><%= flash[:alert] %></p>
>
><%= link_to "로그아웃", destroy_user_session_path, method: :delete, data: {confirm: '로그아웃 할꺼야?'} %>
><%= link_to "로그인", new_user_session_path %>
><%= link_to "회원가입", "/users/sign_up" %>
>```
>
>- i18n 사용하기
>
>```ruby
>i18n이란?
>
>국제화라는 뜻으로 작게 웹에서 보면 각 나라 언어에 맞게 메시지를 출력하도록 도와주는 것이다. 
>internationalization의 약잔데 i와 n사이에 18글자가 있다는 뜻이란다
># https://github.com/tigrish/devise-i18n 사용 설명서
># 1. Gemfile 추가하기
># => gem 'devise-i18n' / bundle install
># 2. locales 건드리기 config 폴더 -> aplication.rb
>config.i18n.default_locale = :de -> config.i18n.default_locale = :ko 로 수정
># 3. $ rails g devise:i18n:views 
># => 이걸 추가하여 버튼 및 바뀌지 않는 view 부분까지 한글로 바꿔주자!
>```
>
>- nickname 추가하기 / devies 모델 수정
>
>```ruby
># 14. nickname 추가하기 / devies 모델 수정
>nickname 추가하기 / devies 모델 수정
>class DeviseCreateUsers < ActiveRecord::Migration
>  ...
>  t.string :nickname, null: false, default: "" 
>  ...
>end
># 15. application_controller.rb에 추가하기
>protected
>	
>def configure_permitted_parameters
>  ...
>  devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
>  # 추가할 유저 정보를 keys: [] 배열안에 넣어준다.
>end
># => rake db:drop -> rake db:migrate
># => index, show.html.erb에서 post.user.email -> post.user.nickname으로 변경해줌
>```
>
>- Movie 모델 만들기
>
>```ruby
># 1. 모델 만들기 
>$ rails g model Movie title poster gener nation director
>
># 2. watchat_boxoffice.json를 만들어 왓차json 정보를 저장한다.
>
># 3. JSON 파일 watcha_boxoffice.json 파일들에 들어있는
># => 영화 정보를 읽어와서
># => Move.create(
># => 	정보를 넣어준다.
># => )
>
># 4. JSON 파일 읽기
>movies = JSON.parse(File.read('watcha_boxoffice.json'))
>list = movies["cards"]
>
>list.each do |movie|
>  Movie.create(
>    title: movie["items"][0]["item"]["title"],
>    poster: movie["items"][0]["item"]["poster"]["original"],
>    genre: movie["items"][0]["item"]["main_genre"],
>    nation: movie["items"][0]["item"]["nation"],
>    director: movie["items"][0]["item"]["directors"][0]["name"]
>  )
>end
>```
>
>- movies 컨트롤러 만들기
>
>```ruby
># 1. 컨트롤러 만들기
>$ rails g controller movies index show
>
># 2. index에서는 영화정보를 모두다 보여주자
><div class="row">
>    <% @movies.each do |movie| %>
>		<div class="card">
>			<a href="/movies/show/<%= movie.id %>"><img src="<%= movie.poster %>" width="100%"  height="280px" alt="Card image cap"></a>
>			<p class="jumbotron-heading"><%= movie.title %></p>
>		</div>
>	<% end %>
></div>
>
># 3. show에서는 영화정보를 하나만 보여주자 !
><div class="card mb-3">
>  <img class="card-img-top" src="<%= @movie.poster %>" width="100%" height="280px" alt="Card image cap">
>  <div class="card-body">
>    <h4 class="card-title"><%= @movie.title %></h4>
>    <p class="card-text">
>      <%= @movie.genre %>
>      <%= @movie.nation %>
>    </p>
>    <p class="card-text">
>      감독 : <%= @movie.director %>
>    </p>
>    <p class="card-text"><small class="text-muted">Last updated 3 mins ago</small></p>
>  </div>
></div>      
>```
>
>- check_admin, admin이 아닐 시 홈페이지로 보내버리는 함수 만들기
>
>```ruby
># application_controller.rb 추가
>def check_admin
>  user_signed_in? && current_user.is_admin?
>end
>
>def get_out
>  redirect_to root_path unless check_admin
>end
>
>helper_method :check_admin
>
># movies_controller.rb 추가
>before_action :get_out, except: [:index, :show]
>```
>
>- 관리자일때만 영화 등록 버튼 보여주기
>
>```erb
><!-- _header.html.erb -->
><header>
>  ...
>  <ul class="list-unstyled">
>    <li class="text-white"><%= current_user.nickname if user_signed_in?%></li>
>    <li><%= link_to "게시판", posts_path, class: "text-white"%></li>
>    <% unless user_signed_in? %>
>    <li><%= link_to "로그인", new_user_session_path,  class: "text-white" %></li>
>    <li><%= link_to "회원가입", "/users/sign_up",  class: "text-white" %></li>
>    <% else %>
>    <li><%= link_to "로그아웃", destroy_user_session_path, method: :delete, data: {confirm: '로그아웃 할꺼야?'},  class: "text-white" %></li>
>    <% end %>
>   </ul>
>  ...
></header>
>```
>
> 
>
>### 영화 평점주기 
>
>```ruby
># 영화 평점 주기
># => 로그인 된 유저 : 점수를 줄 수 있다, 리뷰도 달 수 있다.
># => 평점 - rating: integer, 리뷰 - comment: string, user_id, movie_id
># => Movie has_many :reviews
># => Review belongs_to :moive
># => User has_many :reviews
># => Review belongs_to :user
>
># 1. Review 모델 만들기
>$ rails g model Review rating:integer comment user_id:integer movie_id:integer
>```
>
>- Review form 만들기
>
>```erb
><div class="container">
>  <div class="row">
>    <div class="card">
>      <%= form_tag "/movies/#{@movie.id}/review", method: :post do %>
>        평점 : <%= select_tag "rating", "<option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>".html_safe%><br>
>        리뷰 : <%= text_field_tag :comment %> <%= submit_tag "리뷰달기" %>
>      <% end %>
>    </div>
>  </div>
></div>
>```
>
>- Review 보여주기
>
>```erb
><div class="container">
>  <div class="row">
>    <div class="card">
>      <% @movie.reviews.each do |review| %>
>        <h4 class="card-title">평점 : <%= review.rating %></h4>
>        <p class="card-text">작성자 : <%= review.user.nickname %></p>
>        <p class="card-text">코멘트 : <%= review.comment %></p>
>        <p class="card-text"><small class="text-muted">Last updated 3 mins ago</small></p>
>      <% end %>
>    </div>
>  </div>
></div>
>```
>
>
>
>

