## 멋쟁이사자처럼 프로젝트 실습 24일차

action cable, pusher를 이용해서 실시간 채팅을 만들 수 있음

sendbird 서비스를 이용할 수도 있다.

acloud.guru 로그인 화면만 만들어 api로 제공하는 곳 유료 

https 인증은 letsencrypt.org에서 받아 사용하면 된다. 3개월 무료 !



### 오늘도 실습은 Atom 으로 !



### 1. Devise + CanCanCan + rolify Tutorial

>1. 프로젝트 생성
>
>```
>$ rails new auth_practice
>```
>
>2. Gemfile 추가하기
>
>```ruby
>gem 'devise'
>gem 'cancancan'
>gem 'rolify'
>```
>
>- bundle 
>
>```
>$ bundle install
>```
>
>3. Scaffold Post 추가하기
>
>```
>$ rails g scaffold Post title content:text
>```
>
>4. Devise 추가하기
>
>```
>$ rails g devise:install
>```
>
>- User Devise 생성
>
>```
>$ rails g devise User
>```
>
>5. CanCanCan ability 만들기
>
>```
>$ rails g cancan:ability
>```
>
>6. rolify에서  Role 클래스 만들기
>
>```
>$ rails generate rolify Role User
>```
>
>7. migration 해주기
>
>```
>$ rake db:migrate
>```
>
>

#### role 사용하기

> 1. Add a role to a user
>
> ```
> $ User.create(email: "asd@asd.com", password: "123123", password_confirmation: "123123")
>
> $ user = User.first
> ```
>
> 2. user에 admin 권한 주기
>
> ```
> $ user.add_role :admin
> ```
>
> 3. user에 admin 권한 지우기
>
> ```
> $ user.remove_role :admin
> ```
>
> 4. Assign default role 
>
> ```ruby
> # models/user.rb
> class User < ActiveRecord::Base
>   after_create :assign_default_role
>
>   def assign_default_role
>     self.add_role(:newuser) if self.roles.blank?
>   end
> end
> ```
>
> 5. 새로운 유저 만들고 검사하기
>
> ```
> $ User.create(email: "yanmin@yangmin.com", password: "123123", password_confirmation: "123123")
> $ user = User.second
> $ user.has_role? :newuser => true
> ```
>
> 6. 새로운 admin 만들고 검사하기
>
> ```
> $ User.create(email: "admin@admin.com", password: "123123", password_confirmation: "123123").add_role(:admin)
> $ user = User.last
> $ user.has_role? :admin => true
> ```
>
> 7. user : post => 1 : N 만들기
>
> ```ruby
> # models/post.rb
> class Post < ActiveRecord::Base
>   belongs_to :user
> end
> # models/user.rb
> class User < ActiveRecord::Base
>   ....
>   has_many :posts
> end
>
> $ rails g migration add_user_id_to_posts user_id:integer
> $ rake db:migrate
> ```
>
> 

### 관리자만 글을 쓸 수 있도록 만들어보자!

>#### 이거는 cancancan을 이용 X 
>
>1. views/layouts/application.html.erb
>
>```erb
><body>
>  <%= link_to '회원가입', user_registration_path %>
>  <%= link_to '로그인', new_user_session_path %>
>  <%= link_to '로그아웃', destroy_user_session_path, method: :delete %>
>  <%= yield %>
></body>
>```
>
>2. controller/posts_controller.rb
>
>```ruby
>before_action :authenticate_user!
>before_action :check_admin, except: [:index]
>
>def check_admin
>  redirect_to root_path, notice: "관리자가 아닐 경우 글을 쓸 수 없습니다." if !current_user.has_role? :admin
>end
>```
>
>#### cancan을 이용
>
>1. models/ability.rb
>
>```ruby
>def initialize(user)
>  if user.has_role? :admin
>    can :manage, :all
>    # manage는 아래 애들을 포함
>    # can :index, :all
>    # can :new, :all
>    # can :create, :all
>    # can :edit, :all
>    # can :update, :all
>    # can :show, :all
>    # can :destroy, :all
>  else
>    can :read, :all
>    # read 는 이 두가지를 포함
>    # can :index, :all
>    # can :show, :all
>  end 
>end
>```
>
>2. models/posts.rb
>
>```ruby
>class Post < ActiveRecord::Base
>  resourcify
>  belongs_to :user
>end
>```
>
>3. controller/posts_controller.rb
>
>```ruby
>class PostsController < ApplicationController
>  before_action :set_post, only: [:show, :edit, :update, :destroy]
>  before_action :authenticate_user!
>  # before_action :check_admin, except: [:index]
>  # 위에 애를 주석처리
>  load_and_authorize_resource
>  ...
>  def new
>    @post = Post.new
>    authorize! :write, @post
>  end  
>end
>```
>
>
>
>
>
>

