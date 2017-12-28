## 멋쟁이사자처럼 프로젝트 실습 15일차

#### 오늘도 실습은 Atom으로



### 1. 오늘은 watcha를 더욱 더 꾸며봅시다

```ruby 
# 오늘의 목표

# 1. 게시판(Post -> Scaffold)
# => 댓글(Comment)
# 2. 사진 업로드
# => carrierwave 이용
# 3. 유저 역할 구분 / 관리자 페이지
# => User model -> role, :string, default: "user"
# => role = ["user", "manager", "admin"] (유저는 3개의 역할군으로 나눠져 있다.)
# => 관리자 페이지
# => 1. index, users, posts, movies, reviews 등을 따로따로 관리해주는 페이지를 만들자
```



>### 1. Comment 달기
>
>```ruby
># 1. 코멘트 모델 만들기
># 이번엔 새로운 기술을 이용해서 코멘드 모델을 만들어봄
># 참조하는 형태의 foreign_key를 잡아주는게 좋다 !앞으로는 이런식으로 모델을 만들어주자.
>$ rails g model Comment user_id:references post_id:references content
># db에 이런식으로 생김.
>class CreateComments
>  def chang
>    create_table :comments do |t|
>      t.references :user_id, index: true, foreign_key: true
>      t.references :post_id, index: true, foreign_key: true
>      t.string :content
>    end
>  end
>end
>
>$ rake db:migrate
># 근데 이렇게하면 user_id_id, post_id_id 이런식으로 생김 그래서 변경해야함
># 그리고 models 폴더 -> comment.rb
>class Comment < ActiveRecord::Base
>  belongs_to :user_id -> user 수정해주자
>  belongs_to :post_id  -> post 수정해주자
>end
>
>```
>
> 
>
>### 2. 마이그레이션 변경하기
>
>때로, 마이그레이션을 작성할때 여러분은 실수를 하게 됩니다. 이미 마이그레이션을 실행한 후에는, 단순히 마이그레이션을 수정하고 다시 실행하는 것으로 원하는 변경을 반영할 수는 없습니다.:레일즈는 이미 실행된 마이그레이션이라면, `rake db:migrate`를 수행할때 아무 것도 실행하지 않습니다. 여러분은 반드시 마이그레이션을 되돌(rollback)리고 (예를 들어, `rake db:rollback`를 사용), 마이그레이션을 수정하고 정확한 버전에 대하여 `rake db:migrate`를 실행해야 합니다.
>
>일반적으로 마이그레이션 수정은 좋은 생각이 아닙니다.:여러분은 자신과 동료들을 위해서 추가적인 일을 만들어내고, 만약 제품에 이미 적용된 마이그레이션을 수정하면 골치 아픈 상황을 만들어 낼겁니다. 대신에 필요한 변경을 수행하는 새로운 마이그레이션을 만드세요. 소스 관리 도구에 커밋되지 않은(혹은 좀 더 일반적으로 표현하자면 여러분의 개발 머신 이외에 퍼지지 않은) 새로운 마이그레이션을 수정하는 편이 상대적으로 무해합니다. 이런건 그냥 상식이죠.
>
>```ruby
>$ rails g migration add_user_id_to_comments
>
># AddUserId 마이그레이션 파일이 생김.
>class AddUserIdToComments < ActiveRecord::Migration
>  def change
>    add_column :comments, :user_id, :integer
>    add_column :comments, :post_id, :integer
>  end
>end
>
># RemoveUserIdId 지우기
>$ rails g migration RemoveUserIdIdFromComments user_id_id:integer
>class RemoveUserIdIdFromComments < ActiveRecord::Migration
>  def change
>    remove_column :comments, :user_id_id, :integer
>    remove_column :comments, :post_id_id, :integer
>  end
>end
>```
>
> 
>
>### 3. 영화 올리기
>
>```ruby
># Gemfile에 carrierwave 추가하기
>gem 'carrierwave', '~> 1.0'
>$ bundle install
>
># 업로더 만들기
>$ rails g uploader Photo
># models -> movie.rb에 코드 추가하기
>mount_uploader :poster, PhotoUploader 
># new.html.erb 수정하기
><%= form_tag movies_path, method: :post, multipart: true do %>
>포스터 : <%= file_field_tag :poster %><br>
>
># 이미지 크기 조절
>$ sudo apt-get install imagemagick
># Gemfile에 "mini_magick" 추가하기
>gem "mini_magick"
>$ bundle install
># uploaders 폴더 -> photo_uploader.rb
>include CarrierWave::MiniMagick
>  
># Create different versions of your uploaded files:
># 50 x 50으로 thumb이름으로 이미지 저장
>version :thumb do
>  process resize_to_fit: [50, 50]
>end
># 200 x 200으로 small이름으로 이미지 저장
>version :small do
>  process resize_to_fit: [200, 200]
>end
>
># 이걸 이용하면 저장되는 파일명을 지정할 수 있음.
># def filename
>#   "something.jpg" if original_filename
># end
>```
>
> 
>
>#### 4. Post에 회원 사진 추가하기
>
>```ruby
>$ rails g migration AddImageToPosts image
>
># models 폴더 -> post.rb에 추가
>mount_uploader :image, PhotoUploader
># posts 폴더 -> _form.html.erb에 추가
><div class="field">
>    <%= f.label :image %><br>
>    <%= f.file_field :image %>
></div>
># posts폴더 show.html.erb에 추가
><p>
>  <strong>Image:</strong>
>  <img src="<%= @post.image.small %>">
></p>
>
># posts_controller.rb에 추가
>def post_params
>  params.require(:post).permit(:title, :content, :image)
>end
>```
>
> 하지만 ! 서버에 이미지를 저장하는건 좋지않다 ! 그러므로 우리는 AWS S3 CDN 서비스를 이용할거임 ! 
>
>- AWS CloudFront란 ?
>
>  Amazon CloudFront는 .html, .css, .js 및 이미지 파일과 같은 정적 및 동적 웹 콘텐츠를 사용자에게 더 빨리 배포하도록 지원하는 웹 서비스입니다. CloudFront는 엣지 로케이션이라고 하는 데이터 센터의 전 세계 네트워크를 통해 콘텐츠를 제공합니다. CloudFront를 통해 서비스하는 콘텐츠를 사용자가 요청하면 지연 시간이 가장 낮은 엣지로 라우팅되므로 콘텐츠 전송 성능이 뛰어납니다. 콘텐츠가 이미 지연 시간이 가장 낮은 엣지에 있는 경우 CloudFront가 콘텐츠를 즉시 제공합니다. 콘텐츠가 엣지에 없는 경우 CloudFront에서는 콘텐츠의 최종 버전의 원본으로 식별한 Amazon S3 버킷 또는 HTTP 서버(예: 웹 서버)에서 콘텐츠를 검색합니다.
>
>  ​
>
>### 5. 관리자 기능 추가하기
>
>```ruby
># 1. admin의 역할을 나눠준다. 
># is_admin? 칼럼을 지우고 여러 칼럼으로 나누자
># db -> user.rb t.boolean :is_admin?을 지우고 새로 추가하자
>t.string :role,               null: false, default: "user"
>
># application_controller.rb 수정하기
>def check_admin
>  user_signed_in? && current_user.role == "admin"
>end
># controllers 폴더안에 admin이라는 폴더를 새로 만들자.
># 그리고 application_controller.rb와 
>class Admin::ApplicationController < ApplicationController
>  layout 'admin'
>end
># users_controller.rb를 만들자
>class Admin::UsersController < Admin::ApplicationController
>  def index
>    
>  end
>end
># routes.rb 수정하기
>namespace :admin do
>  get '/users/index' => 'users#index'
>end
>```
>
>```erb
><!-- 또한 views 폴더안에 admin이라는 폴더를 만들고 그 안에 users 폴더를 만들자. 이후 users에는 index.html.erb를 만들고 layouts폴더에는 admin.html.erb를 만들자. -->
>
>admin.html.erb에는 이제 admin의 layout을 만들꺼임 !!
>그리고 index.html.erb는 알아서 수정하셈 !
>```
>
>- 개인정보처리방침 페이지 만들기
>
>```ruby
># 1. posts_controller.rb 수정하기
>def privacy
>  render 'etc/privacy'
>end
>
># 2. routes.rb 수정하기
>get '/posts/privacy' => 'posts#privacy'
># render template: 'etc/privacy'
>```
>
>- 잠깐 ! 레이아웃의 탐색 순서
>
>  Rails는 레이아웃을 탐색하는 경우, 우선 현재 컨트롤러와 같은 이름을 가지는 레이아웃이 `app/views/layouts` 에 있는지를 확인합니다. 예를 들어, `PhotosController` 클래스의 액션을 랜더링하는 경우라고 가정한다면 `app/views/layouts/photos.html.erb`나 `app/views/layouts/photos.builder`를 찾습니다. 해당하는 레이아웃이 존재하지 않는 경우, `app/views/layouts/application.html.erb`나 `app/views/layouts/application.builder`를 사용합니다. `.erb` 레이아웃이 없는 경우, `.builder` 레이아웃이 있다면 그것을 사용합니다. Rails에는 각 컨트롤러나 액션별로 특정 레이아웃을 더 정확하게 지정할 수 있는 방법을 몇가지 제공합니다.
>
>
>
>### 관리자 페이지 구분지어 만들기
>
>```ruby
># 1. admin_controller.rb 에서 추가하기
>class AdminController < ApplicationController
>  def index
>    @users = User.all
>  end
>
>  def users
>    @users = User.all
>  end
>
>  def posts
>    @posts = Post.all
>  end
>
>  def posts_destroy
>    @post = Post.find(params[:id])
>    @post.destroy
>
>    redirect_to :back
>
>    # 특정 게시글을 지운다.
>  end
>
>  def movies
>    @movies = Movie.all
>  end
>
>  def movies_destroy
>    # 특정 영화를 지운다.
>    @movie = Movie.find(params[:id])
>    @movie.destroy
>
>    redirect_to :back
>  end
>
>  def reviews
>    @reviews = Review.all
>  end
>
>  def reviews_destroy
>    # 특정 영화를 지운다.
>    @review = Review.find(params[:id])
>    @review.destroy
>
>    redirect_to :back
>  end
>
>  def to_manager
>    @user = User.find(params[:id])
>
>    @user.update(
>      role: "manager"
>    )
>    flash[:notice] = "매니저로 승급되었습니다."
>    redirect_to :back
>
>  end
>
>  def to_user
>    @user = User.find(params[:id])
>
>    @user.update(
>      role: "user"
>    )
>    flash[:notice] = "양민으로 만들었습니다."
>    redirect_to :back
>  end
>end
>
>```
>
>```erb
><!-- 2. views폴더 -> admin폴더 -> movies, users, posts, reviews 만들기 그중에서 users.html.erb만 보여주겠음. -->
><main role="main" class="col-sm-9 ml-sm-auto col-md-10 pt-3">
>  <h1>관리자 페이지</h1>
>  <h2>유저 목록</h2>
>  <div class="table-responsive">
>    <table class="table table-striped">
>      <thead>
>        <tr>
>          <th>#</th>
>          <th>이메일</th>
>          <th>닉네임</th>
>          <th>권한</th>
>          <th>권한 변경</th>
>        </tr>
>      </thead>
>      <tbody>
>        <% @users.each do |user| %>
>          <tr>
>            <td><%= user.id %></td>
>            <td><%= user.email %></td>
>            <td><%= user.nickname %></td>
>            <td><%= user.role %></td>
>            <!-- <td><%= link_to "[관리자로]" %></td> -->
>            <td>
>              <%= link_to "[매니저로]", "/admin/#{user.id}/to_manager", class: 'btn btn-primary', method: :put, data: {confirm: '진짜 매니저로 바꿀꺼야?'} %>
>              <%= link_to "[양민으로]", "/admin/#{user.id}/to_user", class: 'btn btn-primary', method: :put, data: {confirm: '진짜 양민으로 바꿀꺼야?'} %>
>            </td>
>          </tr>
>        <% end %>
>      </tbody>
>    </table>
>  </div>
></main>
>
><!-- 이런식으로 나머지도 만들어주자 ! -->
>```
>
>

### heroku에 업로드하기

```ruby
# config폴더 -> database.yml 수정
production:
  adapter: postgresql
  encoding: unicode
  # For details on connection pooling, see rails configuration guide
  # http://guides.rubyonrails.org/configuring.html#database-pooling
  pool: 5
  database: production

# Gemfile 추가 / bundle
ruby "2.3.5"
gem 'rails_12factor', group: :production
gem 'pg'
gem 'simple_form'

# heroku 업데이트
$ heroku login
$ git init
$ git add .
$ git commit -m "watcha commit"
$ heroku create
$ git push heroku master

# 끝 고생하셨습니다. 
```

