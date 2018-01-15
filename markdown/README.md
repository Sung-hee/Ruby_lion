## 멋쟁이사자처럼 프로젝트 실습 26일차

### 오늘도 실습은 Atom으로 !



### 1. 간단한 게시판 만들기

>1. Scaffold로 Post(title:string, content:text) 생성
>2. Comment 모델 생성
>3. 두개의 관계 설정 Post has many Comment, Comment belongs_to Post
>4. Post의 Index의 뷰에서 제목(title) 옆에 각각의 Comment의 갯수 보여주기

### 2. 조인을 통해서 DB 성능 향상시키기

>특정 포스트와 관계 되어있는 특정 모델에 해당되는 애를 조인하자
>
>- preload, includes, eager_load 
>
>```ruby
>def index
>  @posts = Post.all.includes(:comments)
>end
>
>$ Post.includes(:tags).where(:tags => {content: 'faker'})
>```

### 3. 마크다운 사용하기 !

>1. 스크립트 추가하기
>
>```erb
><!-- application.html.erb -->
><link rel="stylesheet" href="https://cdn.jsdelivr.net/simplemde/latest/simplemde.min.css">
><script src="https://cdn.jsdelivr.net/simplemde/latest/simplemde.min.js"></script>
>```
>
>2. views/posts/_form.html.erb 수정하기
>
>```erb
><%= form_for(@post) do |f| %>
>	...
><% end %>
><script>
>var simplemde = new SimpleMDE({ element: $("#MyID")[0] });
></script>
>```
>
>3. GemFile 추가하기
>
>```ruby
>gem 'redcarpet'
>```
>
>- bundle install
>
>```
>$ bundle install
>```
>
>4. controllers/posts_controller.rb 수정하기
>
>```ruby
>def show
>  @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions = {})
>end
>```
>
>5. views/show.html.erb 수정하기
>
>```erb
><p>
>  <strong>Content:</strong>
>  <%= @markdown.render(@post.content).html_safe %>
></p>
>```
>
>

