## 멋쟁이사자처럼 프로젝트 실습 9일차

#### Atom과 Rails로 실습 진행 !



### 1. 오늘의 복습은 rails 밑바닥부터 짜기 !

> #### 1. rails_board 만들기 ! 
>
> ```ruby
> # Rails 프로젝트를 생성 'rails_board'
> # posts 컨트롤러 생성
> # Post 모델을 생성
> # get '/' => 'posts#index'
> # 'posts#index'
> #=> 게시글을 모두 보여준다.
> # '/posts/new' '새글 쓰기' 링크를 보여준다.
> # 'posts#new'
> # <form> 통해 title, content -> /posts/create
> # 'posts#create'
> # 1. new에서 날라온 데이터로 Post 모델에 새로운 데이터를 create 한다.
> # 2. 아무것도 render하지 않고, '/' 리다이렉트 시켜준다.
>
> # rails g controller posts index new create -> 컨트롤러들을 다 만들어줌
> # rails g model Post title content -> schema.rb 에 title, cotent를 자동으로 추가해서 만들어줌
> ```
>
>  #### 2. rails 개발에 필요한 잼들!
>
> ```ruby
> # --------------------------------------------------------------------------------------#
> # 이것들은 개발할때 꼭 필요한 잼들 !
> # Gemfile 에 아래의 잼들을 추가하고
> # gem 'rails_db'
> # gem 'awesome_print'
> # gem 'pry-rails'
> # 추가후 bundle install 해주자 !
> ```
>
> #### 3. 개발 꿀팁 !
>
> ```ruby
> # routes.rb 에서 
> # get '/' => 'posts#index' 
> # get '/posts/new' => 'posts#new'
> # get '/posts/create' => 'posts#create'
>
> # 위와 같이 이름이 똑같다면 ! 
> # get '/'
> # get '/posts/new'
> # get '/posts/create' 만 적어줘도 된다 !
> ```
>
> #### 4. 수정, 삭제 만들기
>
> ```ruby
> # routes.rb
> get '/posts/destroy/:id' => 'posts#destroy'
> get '/posts/edit/:id' => 'posts#edit'
> get '/posts/update/:id' => 'posts#update'
>
> # posts_controller.rb
>   def destroy
>     # :id를 통해 Post 찾는다.
>     # 그걸 찾는다.
>     post = Post.find(params[:id])
>     post.destroy
>
>     redirect_to '/'
>   end
>
>   def edit
>     @post = Post.find(params[:id])
>   end
>
>   def update
>     # :id를 통해 Post 찾는다.
>     # 그걸 업데이트 해준다.
>     post = Post.find(params[:id])
>
>     post.update(
>       title: params[:title],
>       content: params[:content]
>     )
>     redirect_to '/'
>   end
> ```
>
> - erb
>
> ```erb
> <!-- index.erb -->
> <!--  데이터베이스에서 우리가 삭제하고자 하는 글을 찾는다. -->
> <!--  해당하는 글을 삭제한다.-->
> <a href="/posts/destroy/<%= list.id%>">삭제</a>
> <!--  데이터베이스에서 우리가 수정하고자 하는 글을 찾는다.-->
> <!--  찾은 글을 <form>에 보여주고 수정할 내용을 입력 받는다.-->
> <!--  입력받은 내용을 받아서 데이터베이스에서 수정한다.-->
> <a href="/posts/edit/<%= list.id %>">수정</a>
>
> <!-- edit.erb-->
> <a href="/">홈으로</a>
> <h1>글 수정하기</h1>
> <form action="/posts/update/<%= @post.id %>">
>   <input type="text" name="title" value="<%= @post.title %>">
>   <input type="text" name="content" value="<%= @post.content %>">
>   <input type="submit" value="확인">
> </form>
> ```
>
> 



### 2. rails_telegram 

>#### 1. rails_telegram 만들기
>
>```ruby
># Gemfile
># gem 'httparty'
># gem 'nokogiri'
># 1. cmd 환경에서 rails new rails_telegram --skip-bundle
># 2. 이후 rails g controller index 입력
># routes.rb
># get '/' => 'messages#index'
># 아래와 같은 코드임
>root 'messages#index'
>get 'messages/index'
>get 'messages/send_msg' => 'messages#send_msg'
>
># messages_controller.rb
>class MessagesController < ApplicationController
>  def index
>  end
>
>  def send_msg
>    url = "https://api.telegram.org/bot"
>    token = "494505815:AAEr9hM4tekek6fYfA03-6n7emUC5vdbjcE"
>
>    res = HTTParty.get("#{url}#{token}/getUpdates")
>    hash = JSON.parse(res.body)
>
>    chat_id = hash["result"][0]["message"]["chat"]["id"]
>
>    text = URI.encode(params[:msg])
>    HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{text}")
>
>    redirect_to '/'
>  end
>end
># db migrate 삭제
># rake db:drop
>```
>
>- index.erb
>
>```erb
><h1>텔레그램 메세지 보내기</h1>
><p>아래에 메세지를 입력해주세용</p>
><form action="/messages/send_msg">
>  메세지 : <input type="text" name="msg">
>  <input type="submit" value="전송">
></form>
>```
>
>- times_ago_in_word 사용하기 
>
>```erb
><%= time_ago_in_words(list.created_at).split(" ")[0] + "분전" %>
><!-- xx 분전 으로 나옴 ! -->
>```
>
>- 데이터 1:N 조인
>
>  유저 (1) => 메시지 유저 정보 (N) / Id, Content, User_id
>
>```ruby
># 1. rails g model User로 User 모델을 하나 더 추가하자.
># 2. Message 모델에 User 모델의 id를 추가하자 !
># 3. t.integer :user_id 을 추가하고 조인을 위하여 rake db:drop 으로 기존의 db를 날린다.
># 4. 그리고 다시 rake db:migrate로 db를 migrate해준다 !
># 1:N의 관계 풀이
># User has many messages 
># Message belongs to user 
># -----------rails에 입력하기-----------
># 5. app -> models ->  user.rb
># => has_many :messages 입력
># 6. app -> models -> message.rb
># => belongs_to :user 입력
># 끝 ! 그러면 이제부터
># erb에서 <%= User.find(list.user_id).email %>  조인 전 user_id의 email 정보 가져오기 코드가
># <%= list.user.email %> 식으로 코딩을 할 수 있음 !
># 퍼펙트 루비 온레일즈 294페이지를 참고해서 공부해도 됨 !
>```
>
>pry에서 데이터 1:N 가지고 놀아보기
>
>```ubuntu
>Message.last
>  Message Load (2.5ms)  SELECT  "messages".* FROM "messages"  ORDER BY "messages"."id" DESC LIMIT 1
>=> #<Message:0x0000555b57515e98
> id: 4,
> content: "prytest",
> user_id: 1,
> created_at: Tue, 19 Dec 2017 06:44:37 UTC +00:00,
> updated_at: Tue, 19 Dec 2017 06:44:37 UTC +00:00>
>[17] pry(main)> msg = Message.first
>  Message Load (2.5ms)  SELECT  "messages".* FROM "messages"  ORDER BY "messages"."id" ASC LIMIT 1
>=> #<Message:0x0000555b57495f68
> id: 1,
> content: "gd",
> user_id: 1,
> created_at: Tue, 19 Dec 2017 06:27:52 UTC +00:00,
> updated_at: Tue, 19 Dec 2017 06:27:52 UTC +00:00>
>[18] pry(main)> msg.user.email
>  User Load (2.1ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 1]]
>=> "asd@asd.com"
>```
>
>
>
>- 회원가입, 로그인 및 로그아웃 기능 만들기
>
>```ruby
># users_controller.rb에 추가
>
>def login
>    # 폼으로 로그인 정보를 받아 /login_session으로 보낸다
>
>  end
>
>  def login_session
>    user = User.find_by(email: params[:email])
>    if user
>      if user.password == params[:password]
>        session[:user_id] = user.id
>        redirect_to '/'
>      else
>        puts "비번이 틀렸소"
>        redirect_to '/users/login'
>      end
>    else
>      puts "회원가입을 하시오"
>      redirect_to '/users/signup'
>    end
>  end
>
>  def logout
>    session.clear
>    redirect_to '/'
>  end
>```
>
>- ApplicationController.rb를 건드려 상속받기
>
>```ruby
>def current_user
>  @user = User.find(session[:user_id]) if session[:user_id]
>end
>
># helper_method :current_user
># 이 코드를 작성하면 helpers에서 코드를 작성하지 않아도 됨 !
>```
>
>- helpers 을 이용해서 뷰에서도 상속받기
>
>```ruby
>def current_user
>  @user = User.find(session[:user_id]) if session[:user_id]
>end
>
># helper_method를 ApplicationController.rb 에서 helper_method :current_user에 쓰게되면 
># 위의 코드들은 작성하지 않아도 됨 !
>```
>
>- ApplicationController.rb 상속받아 messages_controller.rb 에서 사용하기!
>
>```ruby
># text = URI.encode(params[:msg])의 코드를 아래와 같이 수정함 !
>text = URI.encode("#{current_user.email}: " + params[:msg])
>```
>
>- messages_controller.rb에서 로그인 시에만 메세지 작성 할 수 있도록 필터링을 걸어보자 !
>
>```ruby
># 필터링
>  before_action :authorize
>    # 모든 컨트롤러가 발동되기 이전에
>    # 유저가 접속되어 있는지 확인한다.
>
>  def authorize # 로그인 되었는지 판별해라
>    redirect_to '/users/login' unless current_user
>  end
>```



### 3. 번외편 API Key 숨기기 

>#### 1. gitignore 에서 /config/secrets.yml 작성 !
>
>- 이건 git 에 올릴때 특정 파일을 제외하고 올리겠다는 선언을 함 !
>
>#### 2. secrets.yml에서 development 안에다 API Key값을 작성함 !
>
>- ex) telegram_token: 토큰값
>
>#### 3. 원래 파일에는 'Rails.application.secrets.telegram_token' 으로 참조한다
>
>#### 4. 혹시 실수로 커밋 후에 올렸을 경우
>
>- respository를 지우고
>- rm -rf .git 으로 깃 관리폴더를 지우고
>
>#### 5. sinatra 숨기기
>
>- 환경변수 vi .bashrc 에서 ! export TELE_TOKEN = "토큰 값"
>- 코드에선 변수명 = ENV['TELE_TOKEN'] 으로 토큰 값을 불러와서 쓴다 !

