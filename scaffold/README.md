## 멋쟁이사자처럼 프로젝트 실습 13일차

### 오늘도 실습은 atom 으로

#### [ 여담 ]

> angular 는 너무 넓어서 배우기가 힘듬 대신에 괜찮음 레일즈 스럽다. 코드반복이 적다
>
> react는 자유롭다. 대신 초심자에겐 자유롭다고 말하기가 힘들다 베스트 코드가 없음. 
>
> 방법이 다양하므로 베스트 코드가 없다.
>
> vue 는 교육용으로는 괜찮다. 



### 1. Scaffold 스럽게 코드를 짜는걸로 시작

>#### 1. scaffold 란 ?
>
>scaffolding 개념을 추상화해서 말하자면 건물을 짓기 위한 가장 기본이되는 부분을 건축회사에서 건물을 짓기 위한 가장 기본이 되는 재료와 철조물로 뼈대를 만들고 외부표면을 만들어주어서 건축시공자들이 디테일한 건축물을 완성시킬 수 있게 해주는 기능이다. 어플리케이션 개발관점에서 말하자면 개발자가 MVC 모델을 기반으로 어플리케이션을 만들려고 할 때 생산하는 복잡하고 많은 양의 코드를 어플리케이션이 제공하는 템플릿기반으로 Model, View, Controller 에 관련된 코드를 자동으로 생성해주는 기능이다. 
>
>  
>
>### 2. 시작하기전에 우리가 했던 방식으로 먼저 해보자
>
>```ruby
>$ rails new scaffold_practice --skip-bundle
>$ rails g controller posts index new create show edit update destroy
>$ rails g model Post title content:text
>
># 전과 다르게 코딩한 부분만 보여드림 
># 완성코드는 scaffold_practice 에서 코드 확인 !
># html 폼 태그를 루비 폼태그로 만드는 방법임. 여기선 id:title, id:content로 자동으로 매겨짐 !
># 글쓰기 
><%= form_tag("/posts/create", method: "get") do %>
><%= text_field_tag(:title) %><br>
><%= text_area_tag(:content, "", placeholder: "placeholder text", size: "25x10") %>
><%= submit_tag("글쓰기") %>
><% end %>
>
># 수정하기
><%= form_tag("/posts/update/#{@post.id}", method: "get") do %>
><%= text_field_tag(:title, @post.title) %><br>
><%= text_area_tag(:content, @post.content, size: "25x10") %>
><%= submit_tag("수정하기") %>
><% end %>
>
>```
>
>
>
>### 3. 시작하기
>
>- REST API란 ?
>
>  http://meetup.toast.com/posts/92 참고하세요 ! 글 되게 잘씀 ! 보기 편함 ! 
>
>  REST API 설계 시 가장 중요한 항목은 다음의 2가지로 요약할 수 있습니다.
>
>  **첫 번째,** URI는 정보의 자원을 표현해야 한다.
>  **두 번째,** 자원에 대한 행위는 HTTP Method(GET, POST, PUT, DELETE)로 표현한다.
>
>  CRUD
>
>  - 무언가를 Create
>  - 무언가를 Read
>  - 무언가를 Update
>  - 무언가를 Destroy
>  - 무언가를 == 자료 (resource)
>  - 공통의 규약으로 만들자(인간의 언어와 비슷하게)
>
>```ruby
># REST API 규약으로 routes를 바꿔보자 !
>
>Create Post (new -> create)
>get '/posts/new' => 'posts#new'
>post 'posts' => 'posts#create'
>Read All Posts
>get 'posts' => 'posts#index'
>Read 1 Post
>get '/posts/:id' => 'posts#show'
>Update 1 Post (edit -> update)
>put '/posts/:id' => 'posts#update'
>Delete 1 Post 
>delete '/posts/:id' => 'posts#destroy'
>```
>
>- 데이터 유효성 검사 
>
>```ruby
># 글이 저장이 정상적으로 됐을 때, 글이 저장이 안됐을 때 
># 데이터 유효성 검사를 위해서 두단계로 나눔 !
>def create
>  @post = Post.new(
>    title: params[:title],
>    content: params[:content]
>  )
>  if @post.save
>    redirect_to '/'
>  else
>    flash[:alert] = "제목과 내용은 필수로 입력해야함"
>    redirect_to :back
>  end
>end
>
># models 폴더 -> post.rb
>class Post < ActiveRecord::Base
>  validates :title, presence: true
>end
>
># Never trust parameters from the scary internet, only allow the white list through.
># params으로 들어온 어떠한 값들도 안받을래, 나는 require로 title, content 들어온 값만 받을꺼야
>def post_params
>  params.require(:post).permit(:title, :content)
>end
># new.html.erb 수정
># <%= text_field_tag("post[title]") %><br>
># <%= text_area_tag("post[content]", "", placeholder: "placeholder text", size: "25x10") %>
>
># posts.controller.rb 수정
>def create
>  @post = Post.new(
>    title: params["post"]["title"],
>    content: params["post"]["content"]
>  )
>end
>```
>
>- Params
>
>```ruby
># Never trust parameters from the scary internet, only allow the white list through.
># params으로 들어온 어떠한 값들도 안받을래, 나는 require로 title, content 들어온 값만 받을꺼야
># 보안적인 측멱에서 사용함. Strong parameter == whitelist == 허락된 정보만 받아라
>def post_params
>  params.require(:post).permit(:title, :content)
>end
>
># 하나의 변수처럼 넘기기
>input name="title" => params[:title]
>
># 배열처럼 넘기기
>input name="post[]" => params["post"][0] / title
>input name="post[]" => params["post"][1] / content
>
># 해시처럼 넘기기
>input name="post[title]" => params["post"]["title"]
>
># posts_controller.rb 수정
>@post = Post.new(post_params)
>	if @post.save
>      redirect_to '/'
>    else
>      flash[:alert] = "제목과 내용은 필수로 입력해야함"
>      redirect_to :back
>    end
>
>redirect_to "/posts/#{@post.id}" => redirect_to @post
># 무슨 차이?
># @post에는 글의 id, title, content 이 저장되어 있으므로 자동적으로 post의 id로 redirect 해줌 !
>```
>
>- form_for
>
>```erb
><!--이걸 왜쓰냐 ?! form이라는 부분이 new, edit에서 중복이 되니까 !-->
><%= form_for(@blog) do |f| %> 
><!--에서 @blog는 객체가 어떤 것인지 판단해줌 
>ex) blog가 new인지, edit인지 판단해준다. -->
>```
>
> 
>

### 2. 실습 오늘은 퍼펙트 루비온 레일즈 scaffold 공부하기

>### 1. Books 정리 
>
>```ruby
># 1. 프로젝트 생성 및 scaffold 생성
>$ rails new books --skip-bundle
>$ rails g scaffold book isbn title price:integer publish
># 2. 마이그레이션 파일 실행
>$ rake db:migrate
>```
>
>- routes.rb
>
>```ruby
>resource :books
>
># resource 메서드는 굉장히 많은 기능을 제공, rake routes 명령어로 현재 어플리케이션에 정의된 라우트를 확인할 수 있음.
>```
>
>- books_controller.rb
>
>```ruby
># 1. 목록화면 작성
>def index
>  @books = Book.all
>  
>  # 지정된 형식으로 템플릿이 출력되는 형태
>  # html -> html.erb, json -> 변수 @book에 to_json 메서드를 적용해 JSON형식으로 바꾸어 출력
>  # Rails 4 에서는 JSON 형식으로 출력할 때도 표준적인 템플릿(JBuilder)을 사용하도록 바뀜. 그래서 	   respond_to 잘 안씀
>  respond_to do |format|
>    format.html # index.html.erb
>    format.json { render json: @books}
>  end
>end
>```
>
>- index.erb
>
>```erb
><td><%= link_to 'Edit', edit_book_path(book) %></td>
><!-- <%= link_to 'Edit', "/boosk/#{book.id}/edit" %> 이거와 같은 문법 -->
><td><%= link_to 'Destroy', book, method: :delete, data: { confirm: 'Are you sure?' }%></td>
><!-- data-confirm 옵션을 지정하면 link_to 메서드는 링크를 클릭할 때 확인 대화상자가 표시됨. -->
><!-- 돌이킬 수 없는 위험한 처리를 하는 경우에 확인 대화상자를 표시해서 실제 사용자가 문제를 일으키지 않도록 확인하게 만들어줌. -->
>```
>
>등등... 오늘은 여기까지 !!!!!^^thank you:)

실은 공부하다가 신입, 인턴 구직활동에 빠져버림; 그래서 책 정리 내용이 얼마없음 !