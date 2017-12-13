## 멋쟁이사자처럼 프로젝트 실습 5일차

#### 실습은 Atom에서 !



### 1. Real_Asked 만들기 

>#### 1. datamapper로 데이터베이스를 조작하는 Asked 
>
> 
>
>**layout.erb 를 만들어서 중복된 코드들을 관리해 보자.**
>
>- **Do not Repeat yourself = dry (중복하지마라 !) =중복된 코드들을 최소화 하자**
>- yield.rb 연습하기
>
>```ruby
>def hello
>  puts "hello"
>  yield
>  puts "welcome"
>end
>
>hello do
>  puts "hee"
>end
>
># 결과
># hello
># hee
># welcome
>
># 블락개념 - hello출력 - yield 수행 - welcome 출력
># 이걸 layout에 사용해보면 어떻게 될까
>```
>
>- layout.erb 만들기 (이거는 views 폴더 안에 만들어야함 !)
>
>```erb
><!--html head 부분에 중복된 코드르를 작성한 후 반복 돌림-->
><!--app.rb 실행을 하면 layout.erb 코드가 실행되고 body의 yield 부분에서 index.erb로 넘어가 
>index.erb body 부분이 실행됨 -->
><html>
>  <head>
>    <title>Real Asked</title>
>    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css" integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb" crossorigin="anonymous">
>    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
>    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js" integrity="sha384-vFJXuSJphROIrBnz7yo7oB41mKfc8JzQZiCq4NCceLEaO4IHwicKwpJf9c9IpFgh" crossorigin="anonymous"></script>
>    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js" integrity="sha384-alpBpkh1PFOepccYVYDB4do5UnbKysX5WZXm3XxPqe5iKTfUKjNkCk9SaVuEZflJ" crossorigin="anonymous"></script>
>  </head>
>  <body>
>    <%= yield %>
>  </body>
></html>
>```
>
>- **이번에는 회원가입 만들기 !**
>
>```ruby
>get '/signup' do
>
>  erb :signup
>end
>
>get '/register' do
>  User.create(
>    :email => params["email"],
>    :password => params["password"]
>  )
>
>  redirect
>```
>
>- 이번에는 model.rb 만들어 데이터베이스 조작 코드는 따로 빼놓자 !
>
>```ruby
># model.rb -> 데이터베이스 조작코드는 app.rb에 분리하자 !
># app.rb에는 컨트롤 코드만 있는게 좋음 !
>
># need install dm-sqlite-adapter
>DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/asked.db")
>
>class Question
>  ##DataMapper 객체로 Question를 만들겠다.
>  include DataMapper::Resource
>  property :id, Serial
>  property :name, String
>  property :question, Text
>  property :created_at, DateTime
>end
>
>class User
>  include DataMapper::Resource
>  property :id, Serial
>  property :email, String
>  property :password, String
>  property :created_at, DateTime
>end
>
>DataMapper.finalize
>
>Question.auto_upgrade!
>User.auto_upgrade!
>```
>
>- app.rb 일부분
>
>```ruby
># 앞에 model.rb를 선언하여 데이터베이스 코드들을 불러오자 !
>require './model.rb' # 데이터베이스 관련 파일(model)
>```



###2. 쿠키와 세션 

> #### 1. 쿠키와 세션이란 ?
>
>: 쿠키와 세션은 매우 유사하면서도 다른 특징을 지니고 있는데요.
>
>\- 공통점 : 사용자의 정보(데이터)를 저장할 때 이용된다.
>
>\- 차이점 : 
>
>\- 쿠키 : 1) 사용자의 로컬에 저장되었다가 브라우저가 요청시 왔다갔다하게 됨(보안에 취약)
>
>​     2) 세션과 달리 여러 서버로 전송이 가능함
>
>​     3) 세션이 브라우저 단위로 생성되어 브라우저 종료시 사라지는데 반해, 쿠키는 유효시간 설정을 할 수 있음. ex) 7일
>
>\- 세션 : 1) 서버에 데이터를 저장하여 쿠키에 비해 보안에 안전함
>
>​     2) 브라우저 단위로 생성됨 => 익스플로러를 켜고 크롬을 켜고 하면 각각 2개의 세션이 생성되는 것
>
>**[    2. why 쿠키와 세션을 이용한 로그인 처리를 하게 될까?    ]**
>
>: 세션은 위에서 설명한대로 기본 단위가 "웹 브라우저"입니다. 따라서, 웹 브라우저 종료시 소멸하게 되죠...
>
>  그에 반해 쿠키는 사용자 PC에 저장되기 때문에 서버 요청시 전달되는 동안 네트워크 상에서 보안상 취약할 수는 있지만 유효시간을  길게 설정할 수 있어 브라우저가 종료되는 것과 별개로 7일 30일 등 기간을 길게 설정할 수 있습니다.
>
>  하지만,   그렇다고 쿠키에 로그인할 사용자의 정보를 담고 있는다면 정말 정말 너무 너무 보안상 취약할 것을 알 수 있겠죠?
>
>  따라서, 자동 로그인을 구현할 때에는 **"< 세션과 쿠키를 동시에 사용하는 것 >"**이 바람직하다고 생각합니다.
>
>**[    3. 세션과 쿠키를 이용한 자동 로그인 구현에 대한 개요    ]**
>
>: 사용자가 로그인 폼에서 로그인을 할 당시, 자동로그인을 설정하겠다는 CheckBox를 클릭할 경우 사용자의 정보를 저장시키고 유효 기간을 설정한다는 것 까지는 알겠는데 그럼 도대체 어떤 사용자의 정보를 저장시켜 놓아야할까요?
>
>먼저, 사용자가 로그인에 성공한 경우! -> 세션에 사용자 객체(UserVO)를 저장시켰었는데 앞에서 이 객체를 쿠키에 저장시킨다면, 굉장히 보안상 취약합니다. 비밀번호, 아이디 그 외 정보까지 UserVO에 들어 있었죠...
>
>따라서, 로그인에 성공했을 때 사용자 DB 테이블에 sessionId와 유효시간 속성에 값을 지정하는 겁니다. 그리고 쿠키에는 세션Id를넣어 놓는거죠... 그리고 "인터셉터"에서 해당 쿠키값이 존재하면 사용자 DB 테이블 내에서 유효시간 > now() 즉, 유효시간이 아직 남아 있으면서 해당 세션 Id를 가지고 있는 사용자 정보를 검색해 해당 사용자 객체를 반환하는 겁니다.
>
>당연히, 쿠키가 유효시간이 다되면 해당 자동완성 기능은 동작하지 않게 되고 다시 쿠키를 사용하겠다는 선택을 했을 때 동작하게 되겠죠
>
>출처: http://rongscodinghistory.tistory.com/3
>
> [악덕고용주의 개발 일기]
>
> 
>
>**잠깐만 ! Ruby에서 항상 false 인 2가지 !**
>
>```ubuntu
>[1] pry(main)> if false
>[1] pry(main)*   puts "ture"
>[1] pry(main)* else
>[1] pry(main)*   puts "false"
>[1] pry(main)* end
>false
>=> nil
>[2] pry(main)> if nil
>[2] pry(main)*   puts "ture"
>[2] pry(main)* else
>[2] pry(main)*   puts "false"
>[2] pry(main)* end
>false
>=> nil
>
># false와 nil은 항상 false
>```
>
>
>
>#### 2. 그럼 로그인을 만들어보자
>
>```ruby
># 로그인 ?
># 1. 로그인 하려고 하는 사람이 우리 회원인지 검사한다.
># => User 데이터베이스에 있는 사람인지 확인
># => 로그인하려고 하는 사람이 제출한 email이 User DB에 있는지 확인한다.
># 2. 만약에 있으면,
># => 비밀번호를 체크 == 제출된 비번과 User DB에 있는 비번이 같은지 확인
># => 제출 비번 == DB 비번
># => 3. 만약에 맞으면
>#     => 로그인 시킨다.
># => 4. 만약에 비번이 틀리면
>#     => 다시 비번을 치라고 한다.
># 3. 없으면
># => 님 회원아님 -> 회원가입 페이지로 보낸다.
>```
>
>- login 만들기
>
>```ruby
>get '/login' do
>  erb :login
>end
>```
>
>```erb
><h1>로그인</h1>
><form action="/login_session">
>    <div class="form-group">
>      <input type="text" class="form-control" name="email" placeholder="이메일을 입력하세요">
>      <input type="password" class="form-control" name="password" placeholder="비밀번호를 입력하세요">
>    </div>
>    <button type="submit" class="btn btn-primary">Submit</button>
></form>
>
>```
>
>- login_session 만들기
>
>```ruby
>get '/login_session' do
>  @message = ""
>  # 로그인 하려고 하는 사람이 우리 회원인지 검사
>  if User.first(:email => params["email"])
>    # 일치하는 email이 있다면
>    # 패스워드가 일치하는지 검사
>    if User.first(:email => params["email"]).password == params["password"]
>      #패스워드 또한 일치하면 로그인
>      session[:email] = params["email"]
>      @message = "로그인이 되었습니다."
>      redirect to '/'
>      # session = {}
>      # {:emial => "params["email"]"}
>    else
>      @message = "비번이 틀렸습니다."
>    end
>  else
>    @message = "해당하는 이메일의 유저가 없습니다."
>  end
>end
>```
>
>- layout.erb 수정
>
>```erb
><body>
>  <ul class="nav">
>    <li class="nav-item">
>      <a class="nav-link active" href="/">홈으로</a>
>    </li>
>    <!-- if 먼저 로그인이 되어 있을 경우-->
>    <!-- 로그아웃, xxx님 환영합니다.-->
>    <!-- else 로그인이 되어있지 않을 경우 -->
>    <!-- 로그인, 회원가입 버튼 보여주기 -->
>    <% if session[:email] %>
>    <li class="nav-item">
>      <a class="nav-link" href="/logout">로그아웃</a>
>    </li>
>    <% else %>
>    <li class="nav-item">
>      <a class="nav-link" href="/signup">회원가입</a>
>    </li>
>    <li class="nav-item">
>      <a class="nav-link" href="/login">로그인</a>
>    </li>
>    <% end %>
>    <!-- 만약 지금 로그인된 유저가 admin일 경우 -->
>    <% if session[:email]&& User.first(:email => session[:email]).is_admin == true%>
>    <!-- first는 User db에 첫번째 친구가 아니라 !! -->
>    <!-- eamil => session[:email] 이 똑같은 친구들중에 첫번째 친구를 찾아줘-->
>    <li class="nav-item">
>      <a class="nav-link" href="/admin">관리자</a>
>    </li>
>    <% end %>
>  </ul>
>  <h1>Welcome to Real Asked!</h1>
>  <% if session[:email] %>
>  <h5><%= session[:email] %>님 환영합니다.</h5>
>  <% end %>
>  <%= yield %>
></body>
>```
>
>- logout 만들기 !
>
>```ruby
>get '/logout' do
>  # 로그인 된 세션만 클리어 해주면 됨 !
>  # 너무나 간단함 !
>  session.clear
>
>  redirect to '/'
>end
>
>```
>
>

### 3. real_blog 로그인 기능 붙이기

>#### 추가 된 코드 일부분씩만 올릴꺼임 ! 전체코드는 real_blog에서 확인 !
>
>- app.rb
>
>```ruby
># login 컨트롤
>get '/login' do
>  erb :login
>end
>
>get '/login_session' do
>  @message = ""
>  # 로그인하려고 하는 유저가 DB에 저장되어있는지 체크
>  if User.first(:email => params["email"])
>    # 일치하는 유저 정보가 있다면
>    # 패스워드가 일치하는지 검사
>    if User.first(:email => params["email"]).password == params["password"]
>      # 패스워드 또한 일치한다면
>      session[:email] = params["email"]
>      # 로그인이 완료되었으니 메인 홈으로 이동
>      redirect to '/'
>    else
>      # 비밀번호가 틀렸을 때
>      @message = "비밀번호가 틀렸습니다."
>    end
>  else
>    # 유저의 정보가 없을 때
>    @message = "해당하는 유저의 정보가 없습니다."
>  end
>end
># logout 컨트롤
>get '/logout' do
>  session.clear
>
>  redirect to '/'
>end
>```
>
>- layout.erb
>
>```erb
><!-- 공통된 코드들을 layout으로 관리하자 dry코드기법-->
><html>
>  <head>
>    <title>Real Blog</title>
>    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css" integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb" crossorigin="anonymous">
>    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
>    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js" integrity="sha384-vFJXuSJphROIrBnz7yo7oB41mKfc8JzQZiCq4NCceLEaO4IHwicKwpJf9c9IpFgh" crossorigin="anonymous"></script>
>    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js" integrity="sha384-alpBpkh1PFOepccYVYDB4do5UnbKysX5WZXm3XxPqe5iKTfUKjNkCk9SaVuEZflJ" crossorigin="anonymous"></script>
>  </head>
>  <body>
>    <ul class="nav">
>      <li class="nav-item">
>        <a class="nav-link active" href="/">홈으로</a>
>      </li>
>      <% if session[:email] %>
>      <li class="nav-item">
>        <a class="nav-link" href="/logout">로그아웃</a>
>      </li>
>      <% else %>
>      <li class="nav-item">
>        <a class="nav-link" href="/login">로그인</a>
>      </li>
>      <li class="nav-item">
>        <a class="nav-link" href="/signup">회원가입</a>
>      </li>
>      <% end %>
>      <% if session[:email] && User.first(:email => session[:email]).is_admin == true %>
>      <li class="nav-item">
>        <a class="nav-link" href="/admin">관리자</a>
>      </li>
>      <% end %>
>    </ul>
>    <% if session[:email]%>
>    <h5><%= session[:email] %>님 환영합니다.</h5>
>    <% end %>
>    <%= yield %>
>  </body>
></html>
>```
>
>- index.erb
>
>```erb
><!-- 로그인 시 글쓰기 입력 가능-->
><% if session[:email]%>
><form action="/create">
>  <div class="form-group col-md-5">
>    <label for="exampleInputEmail1">제목</label>
>    <input type="text" class="form-control" name="title" id="exampleInputTitle" aria-describedby="titlelHelp" placeholder="제목을 입력하세요">
>    <small id="titleHelp" class="form-text text-muted">제목은 필수로 입력하셔야 합니다.</small>
>  </div>
>  <div class="form-group col-md-5">
>    <label for="exampleInputPassword1">내용</label>
>    <input type="text" class="form-control" name="content" id="exampleInputContent" placeholder="내용을 입력하세요">
>  </div>
>  <button type="submit" class="btn btn-primary">Submit</button>
></form>
><!-- 로그인 후 글쓰기 가능 -->
><% else %>
><h1>Welcome to Real Blog!</h1>
><h5>로그인 후 글쓰기가 가능합니다.</h5>
><% end %>
>```
>
>- model.rb 
>
>```ruby
># model.rb는 컨트롤러와 데이터베이스를 분리하여 관리가 쉽게하기 위하여 만듬
># need install dm-sqlite-adapter
>DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")
>
>class Post
>  include DataMapper::Resource
>  property :id, Serial
>  property :title, String
>  property :body, Text
>  property :created_at, DateTime
>end
>
># 유저 저장 DB
>class User
>  include DataMapper::Resource
>  property :id, Serial
>  property :email, String
>  property :password, Text
>  # 관리자인지 아닌지를 체크하기 위해서 is_admin 추가
>  property :is_admin, Boolean, :default => false
>  property :created_at, DateTime
>end
>
># Perform basic sanity checks and initialize all relationships
># Call this when you've defined all your models
>DataMapper.finalize
>
># automatically create the post table
>Post.auto_upgrade!
>User.auto_upgrade!
>```
>
>



