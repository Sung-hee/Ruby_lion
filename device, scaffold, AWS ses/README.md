## 멋쟁이사자처럼 프로젝트 실습 12일차

#### 오늘도 실습은 Atom으로 ! 



### 1. 오늘은 어제 못한 인스타 이미지 업로드, 좋아요 완성하기 !

> ### 1] Instagram 만들기
>
> ```ruby
> # Instagram Clone 
> # 심심해서 만들었던 rails_insta를 가지고 실습을 이어나가겠습니다 !
>
> # 1. User model & Authentication(login)
>
> # 2. Post model 
>
> # 3. Comment
>
> # 4. User : Post = 1 : N
>
> # 5. Post : Comment = 1 : N
>
> # 6. File Upload(Image)
>
> # 7. Like(Heart) M : N
> ```
>
> ### 1. 파일 업로드를 도와주는 잼을 다운받자 ! gem carrierwave 
>
> ```ruby
> # Gemfile 에다가 아래의 코드를 추가하면 끝 ! 그리고 bundle install을 해주자 !
> # https://github.com/carrierwaveuploader/carrierwave 에서 확인하자
> gem 'carrierwave', '~> 1.0'
>
> # ubuntu 에서 해줄 것들 !
> bundle install
> rails generate uploader Avatar
> rails g migration add_avatar_to_posts avatar:string
> rake db:migrate
>
> # uploaders -> avatar_uploader.rb 에 추가
> class User < ActiveRecord::Base
>   mount_uploader :avatar, AvatarUploader
> end
> ```
>
> 1. new.html.erb 수정
>
> ```erb
> <!-- 사진 올리기 enctype 추가해줘야함 !-->
> <form action="/instas/create" method="post" enctype="multipart/form-data">
>  
> <div class="form-group">
> 	<label for="exampleInputPassword1">사진업로드</label>
> 	<input type="file" class="form-control" name="avatar">
> </div>
> ```
>
> 1. show.html.erb 수정
>
> ```erb
> <!-- 사진 올린거 보여주기 -->
> <p class="card-text"><img src="<%= @post.avatar %>"</p>
> ```
>
>   
>
> ### 번외편
>
> Chrome에서 확장프로그램 'rails panel ' 을 설치하면 !  Chrome 개발자도구에서 Rails 목록이 생기고 Rails에 맞는 개발자 도구가 생김 ! 개발할때 좋음 !
>
> 
>
> ### 2. devise로 로그인 환경 구현하기
>
> ```ruby
> # 실습은 devise_practice
> # 우리가 개발할때 추가하는 젬
>
> gem 'rails_db'
> gem 'awesome_print'
> gem 'pry-rails'
> gem 'better_errors' # 요놈은 에러가 이쁘게 나오게 도와줌
> gem 'binding_of_caller' # 요놈은 better_errors을 쓸때 같이 써줌 ! But 안써도됨 ! 근데 나는 쓸래
> gem 'meta_request'
> ```
>
> #### 1). devise 설치하기
>
> ```ruby
> # https://github.com/plataformatec/devise 참고하세요 ! 사용법이 나와있습니다 !
>
> gem 'devise'
>
> 1. $ rails generate devise:install -> cmd 창에서 설치
>
> 2. config/environments/development.rb:
> config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
>
> 3. Ensure you have flash messages in app/views/layouts/application.html.erb.
> For example:
> 	<p class="notice"><%= notice %></p>
> 	<p class="alert"><%= alert %></p>
>
> 4. $ rails generate devise MODEL
> 5. rkade db:migrate
> ```
>
> #### 2).  scaffold 사용하기
>
> ```ruby
> # 모델이랑 비슷하게 사용됨
> $  rails g scaffold
> # routes 목록들을 볼껀데 grep posts를 사용해서 posts만 보여줌 꼼!수 !
> $ rake routes | grep posts
>
> # 근데 scaffold 사용하니까.. 
> # 2주동안 배운 CRUD가 5분도 안되서 구현이 되네?......뭐지 이 신세계는..
> # https://github.com/hisea/devise-bootstrap-views devise 부트스트랩 사용하기
> # devise 부트스트랩 만들기
> # https://github.com/plataformatec/simple_form
> ```

 

### 2. AWS 사용해서 이메일 보내기

> #### 1) 나에게 보내기
>
> ```ruby
> # 우선 aws 가입부터 !
> # 우리가 사용할껀 Simple Email Service 기능이다 !
> # Simple Email Service에 들어간 후 오레곤으로 지역으로 선택하자 !(한국은 사용하지 못함 ㅜ)
> # Email Addresses에 들어가 gmail을 등록해주자 !
> # 아마존 SES 키를 받게 되면 vi ~/.bashrc 에서 
> # export AWS_ID="UserID" / export AWS_SECRET="UserKey"
>
> # 1. 프로젝트에서 initializers폴더 -> devise.rb 파일을 찾아 들어가
> config.mailer_sender = 'klpoik326@gmail.com' 
> # 으로 수정하자 ! 나는 나한테 보낼꺼기 때문에 내 메일을 입력했음 !
> gem 'aws-sdk-rails' #설치 !
>
> # 2. initializers폴더 -> 새파일 aws-sdk.rb 에서 코드 추가!
> creds = Aws::Credentials.new(ENV['AWS_ID'], ENV['AWS_SCRET'])
> Aws::Rails.add_action_mailer_delivery_method(:aws_sdk, credentials: creds, region: 'us-west-2')
> # 3. config 폴더 -> locals 폴더 -> application.rb 파일에 코드 추가 !
> config.action_mailer.delivery_method = :aws_sdk
> # 4. 이후 프로젝트를 실행시키고 테스트하면 끝 !
> ```
>
> #### 2) 다른사람에게 보내기
>
> ```ruby
> # 이번에는 다른사람에게 보내기 우리는 odk410한테 보낼꺼임 !
> # 1. mailer 만들기
> $ rails g mailer SpamMailer
> # 2. app 폴더 -> mailer -> application_mailer.rb 에다가 
> default from: "AWS SES 승인받은 Email" 으로 수정 !
> # 3. app 폴더 -> mailer -> spam_mailer.rb 에다가
> class SpamMailer < ApplicationMailer
>   default from: "klpoik326@gmail.com"
>   
>   def hiodk410
>      mail(to: "보낼사람 Email", subject: "테스트")
>   end
> end
> # 4. views 폴더 -> spam_mailer 폴더에 파일명.html.erb 생성 후 코드추가
> <h1>테스트</h1> 
> # 5. controller 폴더 -> home_controller.rb에다가 코드추가
> def spam
> 	SpamMailer.hiodk410.deliver_now
>     
> 	redirect_to '/'
> end
> # 6. routes.rb 에 코드 추가하면 끝 !
> get 'home/spam'
> ```
>
> - 이번에는 좀더 수정해서 받는사람, 제목, 내용 폼을 입력하여 보낼 수 있게 만들어 보자
>
> ```ruby
> # app 폴더 -> mailer -> spam_mailer.rb 에다가
> class SpamMailer < ApplicationMailer
>   default from: "klpoik326@gmail.com"
>
>   def hiodk410(receiver, content, text)
>     @text = text
>      mail(to: receiver, subject: content)
>
>   end
> end
> # controller 폴더 -> home_controller.rb에다가 코드추가
> class HomeController < ApplicationController
>   def index
>   end
>
>   def spam
>     SpamMailer.hiodk410(params[:receiver], params[:title], params[:content]).deliver_now
>
>     redirect_to '/'
>   end
> end
>
> ```
>
> ```erb
> <!-- views 폴더 -> spam_mailer 폴더에 파일명.html.erb 생성 후 코드추가 -->
> <h1>안녕</h1>
> <p> <%= @text %> </p>
> # index.html.erb 수정
> <h1>ODK한테 스팸보내자</h1>
> <p>테스트는 끝났다. 준비해라</p>
> <form action="/home/spam">
>   받는 사람 : <input type="email" name="receiver"><br>
>   제목 : <input type="text" name="content" ><br>
>   내용 : <input type="text" name="text" ><br>
>   <input type="submit" value="제출">
> </form>
> ```
>
> 
>
> 트릭스가 뭐야 ? 이거는 텍스트 보내는 템플릿? 임 그렇대 !
>
> ```ruby
> # 1. trix 설치
> gem 'trix'
>
> # 2. bundle install and restart your server to make the files available through the pipeline.
>
> # 3. Import Trix styles in app/assets/stylesheets/application.css:
> *= require trix
>
> # 4.Require Trix Javascript magic in app/assets/javascripts/application.js:
> //= require trix
>
> # index.html.erb 에 추가함
> <input id="x" type="hidden" name="content">
> <trix-editor input="x"></trix-editor>
> <input type="submit" value="제출">
> # hiodk410.html.erb 에 추가함
> <%= @text.html_safe %>
> ```
>
> 

### 3. lightsail 사용하기

>#### 1. 인스턴스 생성
>
>- OS 전용 -> ubuntu로 생성하자 !
>- 생성이 됐으면 터미널 같은 아이콘을 눌러서 실행하자 ! 그러면 우리가 사용하던 ubuntu화면과 똑같음 !
>
>#### 2. 서버 설정하기
>
>## AWS 서버세팅
>
>### 1. AWS EC2 instance 생성
>
>------
>
>### 2. AWS EC2에 SSH로 접속
>
>------
>
>### 3. 개발환경설정
>
>Ubuntu 패키지 업그레이드
>
>```
>sudo apt-get update
>```
>
>Ruby on Rails에 필요한 여러 프로그램 설치
>
>```
>sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev nodejs
>```
>
>rbenv를 활용한 ruby -v 2.3.0 설치
>
>```
>cd
>git clone https://github.com/rbenv/rbenv.git ~/.rbenv
>echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
>echo 'eval "$(rbenv init -)"' >> ~/.bashrc
>exec $SHELL
>
>git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
>echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
>exec $SHELL
>
>rbenv install 2.3.5
>rbenv global 2.3.5
>ruby -v
>```
>
>bundler 설치
>
>```
>gem install bundler
>```
>
>기본 gem을 업데이트 할 때 마다 해줘야함
>
>```
>rbenv rehash
>```
>
>Nginx & Passenger 설치
>
>```
>sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
>sudo apt-get install -y apt-transport-https ca-certificates
>
># Add Passenger APT repository
>sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list'
>sudo apt-get update
>
># Install Passenger & Nginx
>sudo apt-get install -y nginx-extras passenger
>```
>
>Nginx 서버 실행
>
>```
>sudo service nginx start
>```
>
>Nginx 서버 설정(passenger를 사용하겠다)
>
>```
>sudo vi /etc/nginx/nginx.conf
>```
>
>```
>##
># Phusion Passenger
>##
># Uncomment it if you installed ruby-passenger or ruby-passenger-enterprise
>##
>
>include /etc/nginx/passenger.conf;
>```
>
>Passenger 설정(아래쪽 코드 붙여넣기)
>
>```
>sudo vi /etc/nginx/passenger.conf
>```
>
>```
>passenger_ruby /home/ubuntu/.rbenv/shims/ruby; # If you use rbenv
>```
>
>다시 서버 켜기
>
>```
>sudo service nginx restart
>```
>
>최종 서버 설정
>
>```
>sudo vi /etc/nginx/sites-enabled/default
>```
>
>```
>server {
>        listen 80;
>        listen [::]:80 ipv6only=on;
>
>        server_name my_domain.com;
>        passenger_enabled on;
>        rails_env    production;
>        root         /home/ubuntu/my_app_name/public;
>
>        # redirect server error pages to the static page /50x.html
>        error_page   500 502 503 504  /50x.html;
>        location = /50x.html {
>            root   html;
>        }
>}
>```
>
>## Passenger로 Rails 실행하기 본인의 ip로 접속해서 확인하기
>
>Database setup
>
>```
>sudo apt-get install mysql-server mysql-client libmysqlclient-dev
>```
>
>`Gemfile`에 mysql2 추가
>
>```
>gem 'mysql2', group: :production
>```
>
>`config/database.yml` 내용 추가
>
>```
>production:
>    adapter: mysql2
>    encoding: utf8
>    database: app_name_production
>    pool: 5
>    username: <%=ENV['DATABASE_USER']%>
>    password: <%=ENV['DATABASE_PASSWORD']%>
>```

### 4. Heroku 사용하기

>#### 1]. heroku 설치
>
>```ruby
># 1. ubuntu에서 설치해주기
>$ wget -qO- https://cli-assets.heroku.com/install-ubuntu.sh | sh
>$ heroku login
>
># 2. Gemfile 변경하기
>1. gem 'sqlite3' -> group :development do 함수안으로 옮겨준다 end
>2. gem 'pg' 맨 위에 추가함
>3. $ bundle install
>
># 3. 다시 ubuntu에서 설치하기
>$ sudo apt-get install postgresql
>$ sudo apt-get install postgresql-common
>$ sudo apt-get install postgresql-9.5 libpq-dev
>$ bundle install
>
># 4. confing 폴더 -> database.yml
>production:
>  <<: *default
>  database: db/production.sqlite3  
># 을 지우고
>  default: &default
>  adapter: postgresql
>  encoding: unicode
>  # For details on connection pooling, see rails configuration guide
>  # http://guides.rubyonrails.org/configuring.html#database-pooling
>  pool: 5
># 을 추가해줌 
>
># 5. Heroku gems 추가하기
># 먼저 Gemfile에 추가하기
>gem 'rails_12factor', group: :production
>$ bundle install
>ruby "2.3.5" 추가해줌
>
># 6. git을 통해서 저장하기 # ubuntu 프로젝트 폴더안에서 시작할꺼임
>1) $ git init
>2) $ git add .
>3) $ git commit -m "init"
>4) $ heroku create
>5) $ git push heroku master
>
># 데이터 관리할 때 사용함
>1) heroku run rake db:migrate
>
># 그리고 다음부터는 2, 4, 5, 6 만 해주면 됨!
>```

