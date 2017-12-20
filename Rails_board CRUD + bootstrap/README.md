## 멋쟁이사자처럼 프로젝트 실습 10일차

#### 오늘도 실습 환경은 Atom !



### 1. 오늘도 복습으로 시작하기 !

>#### 1. rails_board 만들기 !
>
>```ruby
># 어제만든 rails_board에 어제 마지막 시간에 배운 1:N 조인 및 상속받는 코드 추가하기 !
># 폴더랑 코드가 너무 많아서 따로 안올림 !
># 완성본 코드는 rails_board에서 확인하자 !
>```
>
>- asset -> stylesheets에 보면 css 파일들이 있으므로 css를 이용할 수 있다 !



###2. 무상태 프로토콜 

>**무상태 프로토콜**(stateless protocol)은 어떠한 이전 요청과도 무관한 각각의 요청을 독립적인 트랜잭션으로 취급하는 [통신 프로토콜](https://ko.wikipedia.org/wiki/%ED%86%B5%EC%8B%A0_%ED%94%84%EB%A1%9C%ED%86%A0%EC%BD%9C)로, 통신이 독립적인 쌍의 요청과 응답을 이룰 수 있게 하는 방식이다. 무상태 프로토콜은 [서버](https://ko.wikipedia.org/wiki/%EC%84%9C%EB%B2%84)가 복수의 요청 시간대에 각각의 통신 파트너에 대한 [세션](https://ko.wikipedia.org/wiki/%EC%84%B8%EC%85%98) 정보나 상태 보관을 요구하지 않는다. 반면, [서버](https://ko.wikipedia.org/wiki/%EC%84%9C%EB%B2%84)의 내부 상태 유지를 요구하는 프로토콜은 상태 프로토콜(stateful protocol)로 부른다.
>
>무상태 프로토콜의 예에는 [인터넷](https://ko.wikipedia.org/wiki/%EC%9D%B8%ED%84%B0%EB%84%B7)의 기반이 되는 [인터넷 프로토콜](https://ko.wikipedia.org/wiki/%EC%9D%B8%ED%84%B0%EB%84%B7_%ED%94%84%EB%A1%9C%ED%86%A0%EC%BD%9C)(IP)과 [월드 와이드 웹](https://ko.wikipedia.org/wiki/%EC%9B%94%EB%93%9C_%EC%99%80%EC%9D%B4%EB%93%9C_%EC%9B%B9)의 데이터 통신의 토대가 되는 [HTTP](https://ko.wikipedia.org/wiki/HTTP)가 있다.[[1\]](https://ko.wikipedia.org/wiki/%EB%AC%B4%EC%83%81%ED%83%9C_%ED%94%84%EB%A1%9C%ED%86%A0%EC%BD%9C#cite_note-1) HTTP 프로토콜은 요청 간 사용자 데이터를 저장하는 수단을 제공하지 않는다.
>
>**즉 ! 요청이 왔다갔다하면 데이터에 상태가 다 달라져있다 ! 그러므로 HTTP는 유저의 정보 및 메세지를 알 수가 없다 !**
>
>```ruby
># 무상태 프로토콜 사용법 
># flash ex) flash는 해쉬형태로 사용되고 있음 !
># flash[:notice] = "Post successfully created"
>#	redirect_to @post
># html.erb에서 사용시 <%= flash[:notice] %> 
># 이건 또다른 session의 역할을 하고 생명주기가 짧다 ! 그러므로 바로 그 다음 액션에서만 메세지가 출력이 되고 이후의 액션에서는 메세지가 없어진다 !
>```
>
>```ruby
># flash 메세지 활용하기
># 1. login 성공, logout 성공하면
># => flash[:notice] -> 파랗게
># 2. login 실패 (비번 틀리거나, 아이디가 없거나)
># => flash[:alert] -> 빨갛게
>
><% if flash[:notice]%>
>	<div class="alert alert-primary" role="alert">
>     <p><%= flash[:notice] %></p>
>	</div>
><% elsif flash[:alert] %>
>	<div class="alert alert-danger" role="alert">
>	<p><%= flash[:alert] %></p>
>    </div>
><% end %>
>```
>
>- Application_controller.rb 상속받기
>
>```ruby
>@user ||= User.find(session[:user_id]) if session[:user_id]
>    # @user = @user || User.find(session[:user_id])
>    # => if @user
>    # =>  @user
>    # => else
>    # =>  User.find(session[:user_id])
>```



### 3. render 및 댓글, 부트스트랩 테마 적용하여 게시판 완성하기 !

>- application.html.erb 에서 rander 를 사용하여 코드를 분리하자 !
>
>```erb
>  <%= render 'layouts/header' %>
><%= yield %>
>  <%= render 'layouts/footer' %>
>```
>
>- _header.html.erb 만들기
>
>```erb
><ul class="nav">
>   <li class="nav-item">
>     <a class="nav-link active" href="/">홈으로</a>
>   </li>
>   <li class="nav-item">
>     <a class="nav-link" href="/posts/new">글쓰기</a>
>   </li>
>   <% unless current_user %>
>   <li class="nav-item">
>     <a class="nav-link" href="/users/signup">회원가입</a>
>   </li>
>   <li class="nav-item">
>     <a class="nav-link" href="/users/login">로그인</a>
>   </li>
>   <% else %>
>   <li class="nav-item">
>     <a class="nav-link" href="/users/logout">로그아웃</a>
>   </li>
></ul>
>  <span class="navbar-brand mb-0 h1"><%= current_user.email %>님 환영합니다</span>
><% end %>
>
>
> <% if flash[:notice]%>
> <div class="alert alert-primary" role="alert">
>   <p><%= flash[:notice] %></p>
></div>
> <% elsif flash[:alert] %>
>   <div class="alert alert-danger" role="alert">
>     <p><%= flash[:alert] %></p>
>  </div>
> <% end %>
>
>```
>
>- _footer.html 사용하기
>
>```erb
><nav class="navbar fixed-bottom navbar-expand navbar-dark bg-dark">
>  <span class="navbar-text">Copyright @ 김성희</span>
></nav>
>```
>
>- 게시글에 댓글달기 !
>
>```ruby
># rails g model Comment로 모델을 하나 만들자 !
># 그리고 Post 모델과 1:N의 관계를 만들어주자
># 1(Post) : N (Comment)
># db 셋팅 create_commtents.rb
>class CreateComments < ActiveRecord::Migration
>  def change
>    create_table :comments do |t|
>
>      t.string :content
>      t.integer :post_id
>
>      t.timestamps null: false
>    end
>  end
>end
># 이후 rake db:mrigrate를 해준다.
>
># models -> commtent.rb
>class Comment < ActiveRecord::Base
>  belongs_to :post
>end
># models -> post.rb
>class Post < ActiveRecord::Base
>  has_many :comments
>end
>```
>
>- index.erb 수정
>
>```erb
><h1>게시판</h1>
><%@posts.each do |list|%>
>  <p>
>    제목 : <%= list.title %><br>
>    내용 : <%= list.content %>
>    <!--  데이터베이스에서 우리가 삭제하고자 하는 글을 찾는다. -->
>    <!--  해당하는 글을 삭제한다.-->
>    <a href="/posts/destroy/<%= list.id%>">삭제</a>
>    <!--  데이터베이스에서 우리가 수정하고자 하는 글을 찾는다.-->
>    <!--  찾은 글을 <form>에 보여주고 수정할 내용을 입력 받는다.-->
>    <!--  입력받은 내용을 받아서 데이터베이스에서 수정한다.-->
>    <a href="/posts/edit/<%= list.id %>">수정</a>
>  </p>
>  <form action="/posts/<%= list.id %>/add_comment">
>    <input type="text" name="content">
>    <input type="submit" name="등록">
>  </form>
>  <p>-----댓글목록-----</p>
>  <% list.comments.each do |comment| %>
>    <p><%= comment.content %></p>
>  <% end %>
>
><% end %>
>```
>
>- 도전 실습
>
> ```ruby
># 도전 실습
># Post, Comment 모델을 User와 연결 시켜주기
># 1. 게시판 기능 로그인을 해야지만 작동
># 2. 유저가 작성하는 post, comment에는 유저 정보를 넣어준다.
># 3. 어떤 유저가 작성하였는지도 보여준다.
># ubuntu 에서 수정하는 Post.first.update(user_id: 1) 등등으로 수정 가능!
> ```
>
>1. commtens.rb / posts.rb
>
>```ruby
>class CreateComments < ActiveRecord::Migration
>  def change
>    create_table :comments do |t|
>
>      t.string :content
>      t.integer :post_id
>      t.integer :user_id
>
>      t.timestamps null: false
>    end
>  end
>end
>
>class CreatePosts < ActiveRecord::Migration
>  def change
>    create_table :posts do |t|
>      t.string :title
>      t.string :user_id
>
>      t.string :content
>      t.timestamps null: false
>    end
>  end
>end
># user.rb
>class User < ActiveRecord::Base
>  has_many :posts
>end
># post.rb
>class Post < ActiveRecord::Base
>  has_many :comments
>  belongs_to :user
>end
># commtent.rb
>class Comment < ActiveRecord::Base
>  belongs_to :post
>  belongs_to :user
>end
>
># 로그인을 해야지 게시판 기능 작동
>class PostsController < ApplicationController
>  before_action :authorize
>
>  def authorize
>    redirect_to '/users/login' unless current_user
>  end
>end
>
># posts_controller.rb 수정
>  def create
>    Post.create(
>      user_id: session[:user_id],
>      title: params[:title],
>      content: params[:content]
>    )
>
>    redirect_to '/'
>  end
>```
>
>2. seeds.rb 사용하기
>
>```ruby
>User.create(
>  email: "asdf@asdf.com",
>  password: "123"
>)
>
>User.create(
>  email: "qwer@qwer.com",
>  password: "123"
>)
># 이렇게 써도 됨 !
># User.create([
>#   { email: "asdf@asdf.com", password: "123" },
>#   { email: "qwer@qwer.com", password: "123" }
># ])
># 이후 rake db:seed 를 해준다 !
># seed는 보통 ! 딱 한번만 사용한다. 그러니까 한번 할 때마다 drop->migrate->seed 순서를 거쳐야 한다 !
>
># 도전 과제
># Seed파일 생성 'db/seeds.rb'
># 1. gem faker를 쓴다.
># 2. Post 5개를 만들거임 (랜덤하게)
># 3. comment 10개를 만들거임 (랜덤하게)
># 일정한 데이터들을 입력하여 씨앗으로 삼고 사용할 수 있다.
>Faker::Config.locale = 'ko'
>
>User.create([
>  { email: "asdf@asdf.com", password: "123" },
>  { email: "qwer@qwer.com", password: "123" },
>  { email: "zxcv@zxcv.com", password: "123" }
>])
>
>5.times do
>  Post.create(
>    title: Faker::Address.state,
>    content: Faker::Lorem.words,
>    user_id: rand(1..3)
>  )
>end
>
>10.times do
>  Comment.create(
>    user_id: rand(1..3),
>    post_id: rand(1..5),
>    content: Faker::OnePiece.character
>  )
>end
>```



### 4. 진짜 게시판 처럼 index를 고쳐보자 !

>1. index 페이지 수정하기
>
>```ruby
># show.html.erb 생성 -> index에서 작성자 부터 댓글목록까지 복사해오자 !
># 이후 index.html에는 인사말, 글목록만 남긴다. 글목록은 테이블로 제목, 작성자, 작성일을 나오게한다.
># show.html에는 제목을 클릭 시 제목, 내용, 댓글 등등 보이도록 페이지를 구현함.
># posts.controller.rb 에는
>def show
>  @post = Post.find(params[:id])
>end
># 코드를 추가해주자 ! 이건 show에서 params[:id]를 통해 목록들을 보여주기 위함이다 !
>```



### 5. Board에 사용된 컨트롤러 및 모델 정리

>```ruby
># 컨트롤러
># => posts, users
># 모델
># => Post, User, Commente
># 기능
># => CRUD, 회원가입, 로그인, 로그아웃, Flash(무상태 프로토콜)으로 알림, 부트스트랩, seed
># => seed에는 fake gem으로 기본 글들을 만들어줌
>```
>
>
>
>#### 너무 많이 나가서  완성코드는 rails_board 폴더에서 확인하세요 !



