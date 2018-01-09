## - Anonymous Social Media Project

* Concept

  * 익명의 아이디로 글을 게시하고 공유하는 소셜 미디어.

  * 익명의 아이디는 자신의 관심사(태그)로 글을 올리고 볼 수 있다.****

  * **게시 된 글은 수명을 가지고 있고 다른 유저의 공감하기 버튼을 받으면 글의 수명이 늘어난다.**

  * 수명이 다 한 글은 Database에서 지워진다. 

    ---

    #### 변경 

    수명이 다 한 글은 Database에서 지우지 않고 index 페이지에서만 글을 없애고, 내 피드로 옮긴다.

    ---

* **추가 컨셉 회의**

  * **단, 사용자는 글을 올리는 순간부터 게시글에 대한 제어권이 없음.**

     => 공감을 받아서 글의 수명이 늘어나면 삭제를 못하게 됨.

  * 내용추가기능 => 기존 내용 원본글은 변경이 불가하지만,

    내용은 추가가능 ex) 네이트판 --------추가내용----------

    ​							ㅁㄴㅇㄻㄴㅇㄻ

    ​							ㅁㄴㅇㅁㄴㅁㄴ

    ​						   -------------------------------- 

  *  **반면에, 공감을 받지 못해 수명이 다한 글들에 한해서는 글쓴이가 'U, D' 에 해당하는 제어권을 부여함**

  * **또한, 수명이 다한 글은 '사용자 피드 '에 남아 있음.**

* Core Function

  * 게시글 수명 제한하기.
  * 공감을 받으면 게시글 수명 늘이기.
  * 태그 기능
    * 아이디 만들때 태그로 관심분야를 선택할 수 있다.
    * 지정한 태그와 같은 카테고리의 글을 유저에게 제공.
    * 유저가 글을 포스팅 할 때 태그를 설정할 수 있는 기능을 제공.


* Controller 

  * devise -> rails g devise User

  * scaffold (user -> C, R, U) -> rails g scaffold Post 

    ​               (admin -> C, R, U, D)

  * home controller -> index

  * posts controller -> index, show, edit, new 

* Model 

  * User -> email, password, password_confirmation, name ( naver, kakao 소셜 로그인)
  * Post -> title, content, tag, postimage(carrierwave), user_id
  * Like ->   t.references :user  t.references :post
  * Comment -> post_id: integer, user_id: integer, content

* db 관계

  * User : Post => 1 : N
  * Post : Comment => 1 : N
  * User : Comment => 1 : N
  * Post : Like => 1 : N
  * User : Like => 1 : N

* Naming Rule

  >##### 1. Controller -> application.rb
  >
  >- 현재 접속한 유저 -> current_user
  >- 유저가 로그인 했는지 여부 -> user_signed_in?
  >- 유저가 로그인 했다면 진행 -> authenticate_user!
  >
  >##### 2. Comment, like
  >
  >- Comment -> create_comment, destroy_comment, update_comment
  >- like -> like_board
  >
  > ##### 3. routes
  >
  >#### 아래와 같이 routes 작성 방법을 통일합니다.
  >
  >```ruby
  ># boards 로 된건 posts로 변경합시다.
  ># root 만 root 'home#index'로 사용합시다.
  >
  >Rails.application.routes.draw do
  >  resources :boards do
  >    # member 같은 경우에는 routes에 자동으로 /:id/를 넣어준다.
  >    member do
  >      post '/comments' => 'boards#create_comment', as: :create_comment_to
  >      delete '/comments/:comment_id' => 'boards#destroy_comment', as: :destroy_comment_to
  >      patch '/comments/:comment_id' => 'boards#update_comment', as: :update_comment_to
  >    end
  >    # 하지만 collection는 자동으로 /:id/와 같이 잡아주지 않고 우리가 적은대로 만들어짐.
  >    collection do
  >      get '/:board_id/like' => 'boards#like_board', as: :user_like
  >      get '/page_scroll' => 'boards#page_scroll', as: :scroll
  >    end
  >  end
  >
  >
  >  root 'boards#index'
  >
  >  # sign in as는 패스네이밍을 변경해준다.
  >  get '/signin' => 'sessions#signin', as: :user_signin # 로그인 페이지
  >  post '/signin' => 'sessions#user_signin' # 실제 로그인
  >  # sign up
  >  get '/signup' => 'sessions#signup', as: :user_signup # 회원가입 페이지
  >  post '/signup' => 'sessions#user_signup' # 실제 회원가입
  >  post '/check_email' => 'sessions#check_email'
  >  # sign out
  >  delete 'signout' => 'sessions#signout', as: :user_signout # 로그아웃
  >
  >end
  >```
  >
  >#### 4. private, before_action 
  >
  >```ruby
  ># board -> post로 바꿔서 사용합시다.
  >
  >before_action :set_board, only: [:show, :edit, :update, :destroy]
  >before_action :authenticate_user!, except: [:index, :show]
  >
  ># Use callbacks to share common setup or constraints between actions.
  >def set_board
  >  @board = Board.find(params[:id])
  >end
  >
  ># Never trust parameters from the scary internet, only allow the white list through.
  >def board_params
  >  params.require(:board).permit(:title, :contents)
  >end
  >
  >```
  >​

  ​

  ​