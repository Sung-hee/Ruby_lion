## 멋쟁이사자처럼 프로젝트 실습 18일차

### 오늘도 실습은 Atom으로 !

 

### 1.  시작은 어제 마지막 실습 click 이벤트 !

>1.  click 이벤트를 통해서 show 페이지로 보내기
>
>```javascript
>// 1. tr에 해당하는 html element을 찾는다.
>// 2. html element에 click 이벤트 리스너를 달아준다.
>// 3. 이벤트 헨들러에서는 해당 html element가 가지고 있는 속성을 꺼낸다.
>// 4. 해당 속성값으로 url을 만들어서 페이지를 이동한다.
>
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
>

### 2. 오늘은 jQuery !

>#### 오늘 배울 내용
>
>- CSS Selector에 의한 DOM 탐색 및 조작
>  - parent, sibling을 통해 형제, 부모 DOM을 넘나들 수 있음
>- 이벤트
>  - .click(.이벤트명), .on('click', function() {}) .on('이벤트명', 이벤트 핸들러)
>- AJAX
>
> 
>
>1. 그럼 앞에서 했던 코드를 jQuery형식으로 바꿔보자. 
>
>```javascript
>// jQurey를 이용한 방법.
>
>$(document).ready(function(){
>  // == $(function() {})
>  $('.board').click(function() {
>    location.href = "/boards/" + $(this).data('id');
>    // hover로 주었던 부분이 data- 로 바뀜
>  })
>})
>```
>
>2.  change_color.js 도 jQuery로 바꾸자 !
>
>```javascript
>// jQuery로 바꾸기
>$(document).ready(function(){
>  $('.color-btn').on('mouseover', function(){
>    var color = $(this).attr('haha');
>    $('table').toggleClass(color);
>  })
>  $('.color-btn').on('mouseout', function(){
>    var color = $(this).attr('haha');
>    $('table').toggleClass(color);
>  })
>})
>```
>
>3. change_title.js도 바꿔보자 !
>
>```javascript
>$(document).ready(function(){
>  $('#change-title').click(function(){
>    var title = prompt('바꿀 제목을 입력하세요.');
>      $('.title').text(title);
>  })
>})
>```
>
>4. show.html.erb에 좋아요 버튼 추가하기 
>
>```erb
><%= link_to '<i class="fas fa-trash"></i> 삭제'.html_safe, @board, class: "btn btn-danger", data: {method: :delete, confirm: 'Are you sure?'} %> |
><%= link_to '<i class="fas fa-pencil-alt"></i> 수정'.html_safe, edit_board_path(@board), class: "btn btn-warning" %> |
><button type="button" class="btn btn-outline-primary like"><i class="far fa-thumbs-up"></i>좋아요</button> 
>```
>
>5.  N : N 관계 만들기 (user : board)
>
>```ruby
># comment, like 모델 만들기
>$ rails g model comment
>$ rails g model like
>
># comment 모델 수정하기
>class CreateComments < ActiveRecord::Migration
>  def change
>    create_table :comments do |t|
>      t.references :user # 추가
>      t.references :board # 추가
>      t.text :content # 추가
>      t.timestamps null: false
>    end
>  end
>end
>
># like 모델 수정하기
>class CreateLikes < ActiveRecord::Migration
>  def change
>    create_table :likes do |t|
>      t.references :user
>      t.references :board
>      t.timestamps null: false
>    end
>  end
>end
>
># model 폴더 -> comment.rb 수정하기
>class Comment < ActiveRecord::Base
>  belongs_to :user
>  belongs_to :board
>  
>  def require_permisson?(user)
>    self.user.id == user.id
>  end
>end
># model 폴더 -> like.rb 수정하기
>class Like < ActiveRecord::Base
>  belongs_to :user
>  belongs_to :board
>end
># model 폴더 -> user.rb 수정하기
>class User < ActiveRecord::Base
>  # 암호화된 비밀번호를 가지고 있습니다 !
>  # 이것을 통해서 password_digest에 저장할 수 있음.
>  has_secure_password
>  has_many :likes
>  has_many :comments
>  has_many :boards
>end
>
># model 폴더 -> board.rb 수정하기
>class Board < ActiveRecord::Base
>  belongs_to :user
>  has_many :likes
>  has_many :comments
>
>  def require_permisson?(user)
>    self.user.id == user.id
>  end
>end
>```
>
>6. show.html.erb 수정하기
>
>```erb
><!-- 유저 권한을 검사하여 글쓴이 자기 자신이라면 삭제와 수정 버튼을 보여주자 -->
><% if user_signed_in? && @board.require_permisson?(current_user) %>
><%= link_to '<i class="fas fa-trash"></i> 삭제'.html_safe, @board, class: "btn btn-danger", data: {method: :delete, confirm: 'Are you sure?'} %> |
><%= link_to '<i class="fas fa-cog"></i> 수정'.html_safe, edit_board_path(@board), class: "btn btn-warning" %> |
><% end %>
><button type="button" class="btn btn-outline-primary like"><i class="far fa-thumbs-up"></i>좋아요</button> |
><%= link_to '<i class="fas fa-home"></i> 홈으로'.html_safe, boards_path, class: "btn btn-dark" %>
>
>```
>
>7. board_controller.rb 수정하여 좋아요 클릭 함수를 만들자 
>
>```ruby
>class BoardsController < ApplicationController
>  .....
>  def show
>    @like = Like.where(user_id: current_user.id, board_id: params[:id])
>  end
>  
>  def like_board
>    like = Like.where(user_id: current_user.id, board_id: params[:board_id])
>
>    if like.length > 0
>      # 만약에 좋아요를 이미 누른 상태라면
>      like.first.destroy
>      puts '좋아요 취소'
>    else
>      # 만약에 처음 좋아요를 누른 상태라면
>      like = Like.create(user_id: current_user.id, board_id: params[:board_id])
>      puts '좋아요 누름'
>    end
>    redirect_to :back
>  end
>
>  # 좋아요 취소
>  def dislike_board
>  end 
>end
>```
>
>8. show.html.erb 수정하기 좋아요 눌려있을 때 / 처음 누를 때
>
>```erb
><% if @like.length > 0 %> <!-- 눌려있을 때 -->
>  <a href="/boards/<%= @board.id %>/like"><button type="button" class="btn btn-primary like"><i class="far fa-thumbs-up"></i>좋아요</button></a> |
><% else %> <!-- 처음 누를때 -->
>  <a href="/boards/<%= @board.id %>/like"><button type="button" class="btn btn-outline-primary like"><i class="far fa-thumbs-up"></i>좋아요</button></a> |
><% end %>
>```
>
>



### AJAX(비동기 JS/XML)

>- 동기적 일처리 방식 : 순차적으로 일을 스스로 끝내 나가는 방식
>  - 설거지 -> 빨래 -> 청소 (3시간) / 이놈들을 순차적으로 수행하고 끝내는 것을 기다려야함. 딴 짓 못함
>- 비동기적 일처리 방식 : 해야 할 일을 위임하고 기다리는 방식
>  - 설거지(식기세척기) -빨래(세탁기) -청소(로봇청소기) / 이놈들을 동시에 수행하면서 나는 딴 짓을 할 수잇음 !
>- rails에서의 ajax 
>
>```javascript
>// 1. ajax 요청 만들기
>$.ajax({
>  // ajax로 요청을 보냄 >> JS파일에 대한 요청
>  url: , //요청 보내는 url
>  method: , //http method
>  data: // data parameter
>})
>// 404error
>
>// 2. 요청 보내는 url에 대한 route설정
>// member, collection
>// config/routes.rb에서 설정
>// 404 error
>
>// 3. controller에서 routes 설정한 controller#action 만들어줌
>// controller#action 만들어줌
>// 500 error
>
>// 4. action명과 같은 파일명을 가진 js.erb파일 만들어줌.
>// 오타가 없다면, 정상적으로 동작함
>```
>
>
>
>1. 좋아요 버튼을 ajax를 이용해서 비동기화 시키기 ( show.html.erb )
>
>```erb
><!-- show.html.erb -->
>.....
><% content_for :script do %>
>  <script>
>    $(function(){
>      // 1. 좋아요 버튼을 눌렀을 때
>      $('.like').on('click', function(){
>        // 2. ajax를 이용해서 /board/:board_id/like 라는 url에 요청을 보냄
>        $.ajax({
>          url: '/boards/<%= @board.id %>/like',
>          method: "get"
>        })
>      })
>    })
>  </script>
><% end %>
>```
>
>2.  board_controller.rb 수정하기
>
>```ruby
># 좋아요
>def like_board
>  @like = Like.where(user_id: current_user.id, board_id: params[:board_id]).first
>
>  unless like.nil?
>    # 만약에 좋아요를 이미 누른 상태라면
>    @like.destroy
>    puts '좋아요 취소'
>  else
>    # 만약에 처음 좋아요를 누른 상태라면
>    @like = Like.create(user_id: current_user.id, board_id: params[:board_id])
>    puts '좋아요 누름'
>  end
>end
>```
>
>3. 좋아요 누른사람이 몇명인지 출력하기
>
>```erb
><!-- show.html.erb 코드 수정--> 
>.....
><% if @like.length > 0 %>
>  <button type="button" class="btn btn-primary like"><i class="far fa-thumbs-up"></i>좋아요(<span id="like-count"><%= @board.likes.count %></span>)</button></a> |
><% else %>
>  <button type="button" class="btn btn-outline-primary like"><i class="far fa-thumbs-up"></i>좋아요(<span id="like-count"><%= @board.likes.length %></span>)</button></a> |
><% end %>
>```
>
>4. board_controller.rb에서 함수와 똑같은 파일 만들기 !
>
>```javascript
>// views 폴더 -> boards 폴더에다가 함수와 똑같은 이름의 파일을 만들자
>// 우리는 like_board.js.erb 로 만들면 됨 !
>// 그리고 코드 추가하기.
>
>alert("좋아요 버튼 누름");
>$('.like').toggleClass('btn-outline-primary btn-primary');
>
>var like_count = parseInt($('#like-count').text());
>
>if (<%= @like.frozen? %>){ //삭제 했니?
>  $('#like-count').text(like_count - 1);
>}
>else { // 좋아요 눌렀니?
>  $('#like-count').text(like_count + 1);
>}
>```
>
>5. 댓글 추가하기
>
>```erb
><!-- show.html.erb -->
>
><table class="table">
>  <thead>
>    <tr>
>      <th>댓글</th>
>      <th colspan="2"></th>
>    </tr>
>  </thead>
>  <tbody class="comment-list">
>    <% @board.comments.reverse.each do |comment| %>
>      <tr>
>        <td><%= comment.content %></td>
>        <td></td>
>        <td><button class="btn btn-outline-danger"><i class="fas fa-trash"></i> 삭제</button></td>
>      </tr>
>    <% end %>
>  </tbody>
></table>
><% content_for :script do %>
>  <script>
>    $(function(){
>     ....
>      // 댓글기능
>      // 1. form이 제출되면
>      $('#comment-form').on('submit', function(e){
>        // 2. form의 기본 이벤트를 막아주고
>        e.preventDefault();
>        // 3. form 안의 input 태그에서 입력한 값을 가져온 다음
>        var data = $('#comment-input').val();
>        // 4. 해당 값을 댓글을 등록하는 url로 보냄(ajax 이용)
>        $.ajax({
>          url: '/boards/<%= @board.id %>/comments',
>          method: 'post',
>          data: {
>            contents: data
>          }
>        });
>      });
>    })
>  </script>
><% end %>
>```
>
>6. boards_controller.rb 수정하기
>
>```ruby
>def create_comment
>  @comment = Comment.create(
>    user_id: current_user.id,
>    board_id: params[:id],
>    content: params[:contents]
>  )
>end
>```
>
>7. create_comment.js.erb 만들기
>
>```erb
>// 5. 댓글을 보여주는 table의 tbody에 추가해줌
>alert('댓글 등록됨 !');
>$('.comment-list').prepend(`
>  <tr>
>    <td>${"<%= @comment.content %>"}</td>
>    <td></td>
>    <td><button class="btn btn-outline-danger"><i class="fas fa-trash"></i> 삭제</button></td>
>  </tr>
>  `);
>// 6. input 태그를 비워줌
>$('#comment-input').val('');
>```
>
>

​	



