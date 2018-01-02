## 멋쟁이사자처럼 프로젝트 실습 17일차

### 오늘도 실습은 Atom으로 !  



### 오늘부터는 javascript를 공부하겠습니다 !

> #### 오전 목표
>
> ```ruby
> # model: user, board, comment
> # controller: boards, sessions
> # gem: bootstrap, font-awesome, faker, bcrypt(비밀번호 암호화), kaminari(Pagination)
> ```
>
> 
>
> #### 1. 먼저 새로운 프로젝트를 만듭시다 !
>
> ```ruby
> $ rails new js_class --skip-bundle
> ```
>
>  #### 2. 필요한 Gem 추가하기
>
> ```ruby
> # Import bootstrap4
> gem 'bootstrap'
> # Generate for name
> gem 'faker'
> # Pagination
> gem 'kaminari'
> # Use ActiveModel has_secure_password
> gem 'bcrypt', '~> 3.1.7'
> # 요놈은 작성되어있으니까 주석만 풀어주자 !
>
> $ bundle install
> ```
>
> #### 3. user 모델 만들기
>
> ```ruby
> $ rails g model user email
>   
> def change
>   create_table :users do |t|
>     t.string :email
>     t.string :password_digest # 요놈을 추가해주자
>     t.timestamps null: false
>   end
> end
> ```
>
> #### 4. board scaffold 만들기
>
> ````ruby
> $ rails g scaffold board user:references title contents:text
>
> $ rake db:migrate
> ````
>
> #### 5. 1 : N 관계 만들기
>
> ````ruby
> # models -> user.rb
> class User < ActiveRecord::Base
>   # 암호화된 비밀번호를 가지고 있습니다 !
>   # 이것을 통해서 password_digest에 저장할 수 있음.
>   has_secure_password
>   has_many :boards
> end
> # models -> board.rb
> class Board < ActiveRecord::Base
>   belongs_to :user
> end
> ````
>
> #### 6. Sessions 컨트롤러 만들고 수정하기
>
> ````ruby
> $ rails g controller sessions
>
> # 회원가입 화면
> def signup
> end
>
> # 회원가입 액션
> def user_signup
>   user = User.new(
>     email: params[:email],
>       password: params[:password],
>       password_confirmation: params[:password_confirmation]
>   )
>
>   if user.save
>     redirect_to 'signin', notice: "회원가입 완료!"
>   else
>     redirect_to '/signup', notice: "잘못된 비밀번호 입니다."
>   end
> end
>
>   # 로그인 화면
>   def signin
>   end
>
>   # 로그인 액션
>   def user_signin
>     user = User.find_by(emaill: params[:email])
>
>     # authenticate는 bcrypt 때문에 사용할 수 있는 메소드
>     if user && user.authenticate(params[:password])
>       session[:user_id] = user.id
>       redirect_to '/', notice: "로그인에 성공했습니다."
>     else
>       redirect_to '/signin', notice: "이메일이 없거나, 비밀번호가 틀렸습니다."
>     end
>   end
>
>   # 로그아웃
>   def signout
>     # delete는 clear와 하는 역할은 같다 ! 여기서는 delete를 이용해 id만 날리겠음 !
>     session.delete(:user_id)
>     redirect_to '/', notice: "로그아웃 성공!"
>   end
> ````
>
> - 회원가입 시 이메일 인증 기능을 사용하고 싶으면 google에 rails devise confirmable를 검색 해보자 !
>
>  #### 7. routes.rb 수정하기
>
> ```ruby
> Rails.application.routes.draw do
>   resources :boards
>
>   root 'boards#index'
>   # sign in as는 패스네이밍을 변경해준다.
>   get '/signin' => 'sessions#siginin', as: :user_signin # 로그인 페이지
>   post '/signin' => 'sessions#user_signin' # 실제 로그인
>   # sign up
>   get '/signup' => 'sessions#signup', as: :user_signup # 회원가입 페이지
>   post '/signup' => 'sessions#user_signup' # 실제 회원가입
>   # sign out
>   delete 'signout' => 'sessions#signout', as: :user_signout # 로그아웃
> end
> ```
>
> #### 8. signin, signup 페이지 만들기
>
> ```erb
> <!-- signin.html.erb -->
> <%= form_tag signin_path, method: :POST, class: "form-signin" do %>
>     <h2 class="form-signin-heading">Please sign in</h2>
>     <label for="inputEmail" class="sr-only">Email address</label>
>     <input type="email" name="email" class="form-control" placeholder="Email address" autofocus>
>     <label for="inputPassword" class="sr-only">Password</label>
>     <input type="password" name="password" class="form-control" placeholder="Password">
>     <button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>
> <% end %>
>
> <!-- signup.html.erb -->
> <%= form_tag signup_path, method: :POST, class: "form-signin" do %>
>     <h2 class="form-signin-heading">Please sign up</h2>
>     <label for="inputEmail" class="sr-only">Email address</label>
>     <input type="email" name="email" class="form-control" placeholder="Email address" autofocus>
>     <label for="inputPassword" class="sr-only">Password</label>
>     <input type="password" name="password" class="form-control" placeholder="Password">
>     <label for="inputPassword" class="sr-only">Password Confirmation</label>
>     <input type="password" name="password_confirmation" class="form-control" placeholder="Password Confirmation">
>     <button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>
> <% end %>
> ```
>
> - bootstrap 사용하기
>
> ````css
> gem bootstrap 을 이용하기 위해서는 assets 폴더를 수정해야 함 !
> 1. stylesheet 폴더 -> application.css -> application.scss로 확장자 수정 !
> 2. @import 'bootstrap'; //그리고 이놈을 추가해주자 !
> 3. javascript 폴더 -> application.js 
> 	//= require turbolinks 이놈 밑에다가 
> 	//= require popper 요놈들을 추가해주자 !
> 	//= require botstrap 
> 4. 마지막으로 https://getbootstrap.com/docs/4.0/examples/signin/signin.css에 들어가서 
>    css 소스들을 application.scss폴더에 추가해주자 !
> ````
>
> #### 9. navbar 만들기
>
> ```erb
> <!-- application.html.erb -->
> <nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-top">
>   <a class="navbar-brand" href="#">Navbar</a>
>
>   <div class="collapse navbar-collapse" id="navbarsExampleDefault">
>     <ul class="navbar-nav mr-auto">
>       <li class="nav-item">
>         <a class="nav-link" href="#">Home <span class="sr-only">(current)</span></a>
>       </li>
>       <li class="nav-item">
>         <a class="nav-link" href="#">Board</a>
>       </li>
>       <li class="nav-item dropdown">
>         <a class="nav-link dropdown-toggle" id="dropdown01" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">User</a>
>         <div class="dropdown-menu" aria-labelledby="dropdown01">
>             <%= link_to "Sign out", user_signout_path, class: "dropdown-item", data: {method: :delete, confirm: "로그아웃 할거야?" }%>
>             <%= link_to "Sign in", user_signin_path, class: "dropdown-item" %>
>             <%= link_to "Sign un", user_signup_path, class: "dropdown-item" %>
>         </div>
>       </li>
>     </ul>
>  </div>
> </nav>
> ```
>
> #### 10. application.rb를 수정하여 로그인한 사람만 board에 접근 가능하도록 만들자.
>
> ```ruby
> helper_method :current_user, :user_signed_in?
>
> def current_user
>   # 현재 접속한 유저
>   # session[:user_id] 로 사용하면 id 값이 리턴이 되지만
>   # session[:user_id].nil? 로 사용하면 true, false로 리턴이되어 명시적으로 보여줄 수 있음.
>   if !session[:user_id].nil?
>     @current_user = User.find(session[:user_id])
>   end
>     @current_user
>     # @current_user ||= User.find(session[:user_id])
> end
>
> def user_signed_in?
>   # 유저가 로그인 했는지 여부(boolean)
>   # session[:user_id] 비어있으면 -> 로그인 안한거 -> false
>   # session[:user_id] 채워져있으면 -> 로그인 한거 -> true
>   !session[:user_id].nil?
> end
>
> def authenticate_user!
>   # 유저가 로그인 했다면 진행
>   # 유저가 로그인 하지 않았따면 로그인 페이지로
>   if session[:user_id].nil?
>     redirect_to '/signin', notice: "로그인이 필요합니다."
>   end
> end
> ```
>
> - bang(!) => 내용물을 변화시킬 수 있는 메소드에 붙여줌
>
> ```ruby
> # element.upcase! => element 자체가 변화함
> # element2 = element.upcase => return 값이 변화함
> ```
>  #### 11. 로그인 여부 검사를 만들었으니 application.html.erb 수정하기
>
> ```erb
> <div class="dropdown-menu" aria-labelledby="dropdown01">
>   <% if user_signed_in? %>
>   	<a class="dropdown-item"> <%= current_user.email %></a>
>   	<%= link_to "Sign out", user_signout_path, class: "dropdown-item", data: {method: :delete, confirm: "로그아웃 할거야?" }%>
>   <% else %>
>   	<%= link_to "Sign in", user_signin_path, class: "dropdown-item" %>
>   	<%= link_to "Sign up", user_signup_path, class: "dropdown-item" %>
>   <% end %>
> </div>
>
>
> <div class="container" style="margin-top: 5rem !important;">
>   <% if flash[:notice] %>
>   
>   <div class="alert alert-success" role="alert">
>         <%= flash[:notice] %>
>       </div>
>     <% end %>
>     <%= yield %>
> </div>
> ```
>
>  

### 자바스크립트 사용하기

>**html은 웹페이지, CSS은 꾸미기, Javascript는 동적으로 컨텐츠를 바꿈** 
>
> 
>
>####Javascript
>
>- 이벤트(Envent: click, hover, keydown, mouseup, mouserdown)
>- 이벤트 리스너(on)
>- 이벤트 핸들러(function())
>
>### 1. alert, confirm, prompt 사용하기
>
>```erb
>alert("기본 경고창")
>confirm("Yes or No") 
>prompt("입력이 있는 경고창")
>```
>
>### 2. yield와 content_for 사용하기
>
>```erb
><!-- application.html.erb 수정하기 -->
><div class="container" style="margin-top: 5rem !important;">
>  <% if flash[:notice] %>
>  <div class="alert alert-success" role="alert">
>    <%= flash[:notice] %>
>  </div>
>    <% end %>
>    <%= yield %>
></div>
><%= yield :script %>  <!-- content_for :script를 찾는다 -->
>
><!-- index.html.erb 수정하기 -->
><%= link_to '새글쓰기', new_board_path, class: "btn btn-dark" %>
><% content_for :script do %>
>  <script>
>    alert("여기는 인덱스 페이지 입니다.")
>  </script>
><% end %>
>```
>
> ### 3. index.html.erb에서 javascript 사용하기
>
>```erb
><% content_for :script do %>
>  <script>
>    // alert("여기는 인덱스 페이지 입니다.")
>    // 1. 이벤트를 넣어줄 html element찾고
>    var btn = document.getElementById('change-title');
>    // 2. 해당 element에 원하는 이벤트를 달아준다.
>    btn.onclick = function() {
>      // 3. 이벤트가 발생했을 경우 실행하는 함수(function())를 만들어준다.
>      // 실행문
>      // 버튼을 누르면 prompt창이 떠서 입력메세지를 입력할 수 있고,
>      // 해당 내용으로 모든 제목을 바꿔버립니다.
>      var title = prompt('바꿀 제목을 입력하세요.');
>      // 바꿀 내용물들(html element)이 어디에 있는지 찾아야함.
>      // getElement*** -> 내용물을 1개만 가지고 온다. -> 여러개 있어도 return값은 1개
>      // getElements*** -> 내용물들을 여러개 가지고 온다. -> 1개만 있어도 return값은 배열
>      // getElements***로 찾은 html element를 사용할 때에는 반복문, 혹은 index로 하나씩 조정
>      var titles = document.getElementsByClassName('title');
>
>      for(var i = 0; i < titles.length; i++) {
>        // 해당 내용으로 모든 제목을 바꿔버립니다.
>        titles[i].textContent = title;
>      }
>    }
>  </script>
><% end %>
>```
>
>- getElement*** -> 내용물을 1개만 가지고 온다. -> 여러개 있어도 return값은 1개
>- getElements*** -> 내용물들을 여러개 가지고 온다. -> 1개만 있어도 return값은 배열
>- getElements***로 찾은 html element를 사용할 때에는 반복문, 혹은 index로 하나씩 조정
>
> ```javascript
>console.log(document.getElementById('id'));
>console.log(document.getElementsByClassName('title'));
> ```
>
>### 4. public폴더에 change_title.js 만들어 script 코드 분리시키기
>
>- 앞서 작성한 코드를 change_title.js로 옮기자
>
>````javascript
>  // alert("여기는 인덱스 페이지 입니다.")
>    // 1. 이벤트를 넣어줄 html element찾고
>    var btn = document.getElementById('change-title');
>    // 2. 해당 element에 원하는 이벤트를 달아준다.
>    btn.onclick = function() {
>      // 3. 이벤트가 발생했을 경우 실행하는 함수(function())를 만들어준다.
>      // 실행문
>      // 버튼을 누르면 prompt창이 떠서 입력메세지를 입력할 수 있고,
>      // 해당 내용으로 모든 제목을 바꿔버립니다.
>      var title = prompt('바꿀 제목을 입력하세요.');
>      // 바꿀 내용물들(html element)이 어디에 있는지 찾아야함.
>      // getElement*** -> 내용물을 1개만 가지고 온다. -> 여러개 있어도 return값은 1개
>      // getElements*** -> 내용물들을 여러개 가지고 온다. -> 1개만 있어도 return값은 배열
>      // getElements***로 찾은 html element를 사용할 때에는 반복문, 혹은 index로 하나씩 조정
>      var titles = document.getElementsByClassName('title');
>
>      for(var i = 0; i < titles.length; i++) {
>        // 해당 내용으로 모든 제목을 바꿔버립니다.
>        titles[i].textContent = title;
>      }
>    }
>````
>
>- index.html.erb 수정하기
>
>```erb
><% content_for :script do %>
>  <script>
>  </script>
>  <script src="change_title.js"></script>
><% end %>
>```
>
>### 5. 세개의 버튼을 만들어서 글씨 컬러 바꾸기
>
>```erb
><!-- haha와 같이 속성의 네임은 아무거나 지정해줘도 됨 ! -->
><a class="btn btn-danger color-btn" haha="text-danger">빨강</a>
><a class="btn btn-primary color-btn" haha="text-primary">파랑</a>
><a class="btn btn-warning color-btn" haha="text-warning">노랑</a>
>
><% content_for :script do %>
>  <script>
>    // 세개의 버튼 html element를 찾아서
>    var btns = document.querySelectorAll('.color-btn');
>    // 각각의 버튼에 해당하는 색상을 정하고
>    // 빨강 -> text-danger, 파랑 -> text-primary, 노랑 -> text-warning
>    for(var i = 0; i < btns.length; i++){
>      console.dir(btns[i]);
>      // 버튼 하나에 마우스를 올렸을 때
>      btns[i].onmouseover = function(){
>        var color = (this.getAttribute('haha'));
>        // 각각의 정해진 색상 class를 table에 넣어준다.
>        var table = document.getElementsByClassName('table')[0];
>        console.log(table);
>        table.setAttribute('class', "table table-hover " + color);
>      }
>    }
>  </script>
>  <script src="change_title.js"></script>
><% end %>
>```
>
>**이벤트, 이벤트 리스너, 이벤트 핸들러** 
>
>- 이벤트: 마우스 오버(mouserover)
>- 이벤트 리스너: onmouseover
>- 이벤트 핸들러: 복잡한 function()
>
>### 6. 이번에도 public 폴더에 change_color.js에 스크립트 코드들을 옮겨서 관리하자
>
> 
>
>### 7.  테이블을 클릭하면 해당 글을 보여줄 수 있도록 만들어주자 !
>
>```javascript
>// change_show.js에 코드 추가하기
>var table = document.getElementsByTagName('tr');
>
>for(var i = 0; i < table.length; i++){
>  table[i].onclick = function(){
>    var show = (this.getAttribute('hoho'));
>    window.location.href = "/boards/" + show;
>  }
>}
>```
>
>```erb
><!-- index.html.erb에 추가하기 -->
><script src="change_show.js"></script>
>```
>
>

