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
>
>  
>
> ### 3. AWS 사용해서 이메일 보내기
>
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
> # 3. config 폴더 -> application.rb 파일에 코드 추가 !
> config.action_mailer.delivery_method = :aws_sdk
> # 4. 이후 프로젝트를 실행시키고 테스트하면 끝 !
> ```
>
> #### 2) 다른사람에게 보내기
>
> ```ruby
>
> ```
>
> 
>
> 

