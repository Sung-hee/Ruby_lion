## 멋쟁이사자처럼 프로젝트 실습 23일차

### 실습은 Atom으로 !



### 1. 우선 페이스북 로그인으로 실습을 시작하겠습니다

>새로운 프로젝트 만들기
>
>```
>$ rails new fb_login --skip-bundle
>```
>
>Post라는 scaffold 만들기 / migrate 하기
>
>```
>$ rails g scaffold Post title content:text
>$ rake db:migrate
>```
>
>routes.rb 수정하기
>
>```ruby
>root 'posts#index'
>```
>
>devise 추가하기
>
>- Gemfile 추가하기
>
>```ruby
># Gemfile 
>gem 'devise'
>$ bundle install
>```
>
>- devise 설치하기
>
>```ruby
>$ rails g devise:install
>```
>
>- config -> environment -> development.rb 추가하기
>
>```ruby
>config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
>```
>
>devise로 user 만들기
>
>```ruby
>$ rails g devise User
>```
>
>Facebook 로그인하기
>
>- https://developers.facebook.com/ 접속하여 로그인하고 새앱을 만들자



### 2. 본격적으로 시작 !

>https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview 기술문서 참조하여 facebook login을 시작해보자 !
>
>- Gemfile 추가하기
>
>```ruby
># facebook login
>gem 'omniauth-facebook'
>```
>
>- bundle install 해주자
>
>```
>$ bundle install
>```
>
>- User 모델에 provider, uid 추가해주자 !
>
>```
>$ rails g migration AddOmniauthToUsers provider:string uid:string
>$ rake db:migrate
>```
>
>- config/initializers/devise.rb 수정하기
>
>```ruby
>config.omniauth :facebook, "APP_ID", "APP_SECRET"
>```
>
>- app/models/user.rb 수정하기
>
>```ruby
>devise :omniauthable, omniauth_providers: %i[facebook]
>```
>
>- config/routes.rb 수정하기
>
>```ruby
>devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
>```
>
>- app/controllers/users/omniauth_callbacks_controller.rb 만들기
>  - users라는 폴더를 먼저 만든 후 controller.rb를 만들자 !
>
>```ruby
>class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
>  def facebook
>    # You need to implement the method below in your model (e.g. app/models/user.rb)
>    @user = User.from_omniauth(request.env["omniauth.auth"])
>
>    if @user.persisted?
>      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
>      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
>    else
>      session["devise.facebook_data"] = request.env["omniauth.auth"]
>      redirect_to new_user_registration_url
>    end
>  end
>
>  def failure
>    redirect_to root_path
>  end
>end
>```
>
>- app/models/user.rb 수정하기
>
>```ruby
>def self.from_omniauth(auth)
>  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
>    user.email = auth.info.email
>    user.password = Devise.friendly_token[0,20]
>    # user.name = auth.info.name   # assuming the user model has a name 
>    # user.image = auth.info.image # assuming the user model has an image
>    # If you are using confirmable and the provider(s) you use validate emails,
>    # uncomment the line below to skip the confirmation emails.
>    # user.skip_confirmation!
>  end
>end
>```
>
>- 하나 더 추가하자 !
>
>```ruby
>def self.new_with_session(params, session)
>  super.tap do |user|
>    if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
>      user.email = data["email"] if user.email.blank?
>    end
>  end
>end
>```
>
>- Logout links
>
>```ruby
># config/routes.rb
>devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' } do
>  delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
>end
>```
>
>

### 3. 테스트코드 작성하기

>app/models/post.rb 수정하기
>
>```ruby
>class Post < ActiveRecord::Base
>  validates :title, presence: true,
>                    length: { minimun: 2 }
>  # validates :content
>end
>
>```
>
>test/models/post_test.rb 수정하기
>
>1. assert 사용 => 미리 작성된 코드를 테스트할 때 주로 사용
>
>```ruby
>class PostTest < ActiveSupport::TestCase
>  # test "the truth" do
>  #   assert true
>  # end
>  test "Post의 타이틀은 두 글자 이상이어야 한다" do
>    post = Post.new(title: "ad")
>    assert post.save # 참이되는 조건
>  end
>end
>```
>
>2. refute 사용 => 미리 작성된 코드가 아닌 테스트에서 코드를 작성하며 시작할 때 주로 사용
>
>```ruby
>test "Post의 타이틀은 nil이 아니어야 한다." do
>    post = Post.new(title: "")
>    refute post.save
>  end
>
>  test "title은 반드시 2글자 이상이어야 한다." do
>    post = Post.new(title: "a")
>    refute post.save
>  end
>
>  test "title은 반드시 100글자 이하이어야 한다." do
>    post = Post.new(title: Faker::Lorem.words(200))
>    refute post.save
>  end	
>```
>
>실행하기
>
>```
>$ rake test:models
>```
>
>

