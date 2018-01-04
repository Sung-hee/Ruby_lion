## 멋쟁이사자처럼 프로젝트 실습 19일차

### 오늘도 실습은 Atom으로 !



### 1. 오늘의 시작은 어제꺼에 이어서 댓글 삭제부터 시작함 !

>#### 댓글 삭제
>
>1. routes.rb 수정하기
>
>```ruby
>member do
>  post '/comments' => 'boards#create_comment', as: :create_comment_to
>  delete '/comments/:comment_id' => 'boards#destroy_comment', as: :destroy_comment_to
>end
>```
>
>2.  show.html.erb에 댓글 삭제 코드 추가하기
>
>```ruby
>$('.comment-list').on('click', '.delete-comment', function(){
>  var id = $(this).data('id');
>  $.ajax({
>    url: "/boards/<%= @board.id %>/comments/" + id,
>    method: "delete"
>  });
>});
>```
>
>3. board_controller.rb 수정하기
>
>```ruby
>def destroy_comment
>  @comment = Comment.find(params[:comment_id]).destroy
>end
>```
>
>4. destroy_comment.js.erb 만들기
>
>```javascript
>alert("댓글삭제!");
>$('#comment-<%= @comment.id %>').fadeOut().remove();
>```
>
> 
>
>#### 댓글 수정
>
>1. show.html.erb에 댓글 수정 코드 추가하기
>
>```erb
><script>
>// 댓글 수정하기
>      // 1. 댓글 내용이 들어있는 td태그 부분을 누르면
>      $('.comment-list').on('click', '.comment', function(){
>        var text = $(this).text();
>        var id = $(this).data('id');
>
>        console.log(id);
>        // 하나의 input 창이 열려있는 경우, 추가적인 input 창을 못열게
>        if ($(this).parents('.comment-list').find('.comment-form').length > 0){
>          // 이미 열려있는 comment-form이 있다면
>          alert('이미 수정중인 comment가 있습니다');
>          return false;
>        }
>        // 3. 수정 완료 버튼을 삭제버튼 옆에 추가한다.
>        // 3번이 왜 여깄냐 ! input 태그로 바꾸면 siblings을 찾지 못해 버튼을 추가하기가 힘들기 때문 !
>        // 그러니까 input 타입으로 바꾸기 전에 버튼을 추가하자 !
>        $(this).siblings()[0].innerHTML = '<button class="btn btn-dark my-2 my-sm-0 update-comment" type="submit"><i class="fas fa-pencil-alt fa-spin"></i> 완료</button>';
>        // 2. 해당 부분을 댓글 내용이 들어있는 input 태그로 바꾸고
>        $(this).replaceWith(`<td class="edit-comment"><input class="form-control comment-form" value="${text}"><input class="comment-id" type="hidden" value="${id}"></td>`);
>      });
>      // 완료 버튼을 누르면 작성했던 내용이 서버로 가서 저장(update)
>      $('.comment-list').on('click', '.update-comment', function(){
>        // 1. input 태그에 있는 내용물을 뽑아서 서버로 보냄
>        var text = $('.comment-form').val();
>        var id = $('.comment-id').val();
>        
>        $.ajax({
>          url: '/boards/<%= @board.id %>/comments/' + id,
>          method: 'patch',
>          data: {
>            content: text
>          }
>        })
>        // 2. input 태그가 있는 부분을 다시 일반 td 태그로 변환
>        $('.edit-comment').replaceWith(`<td class="comment" data-id="">${$('.comment-form').val()}</td>`);
>        // 3. 완료버튼 없애주기
>        $('.update-comment').remove();
>      })
></script>
>```
>
>2. routes.rb 수정하기
>
>```ruby
>patch '/comments/:comment_id' => 'boards#update_comment', as: :update_comment_to
>```
>
>3. board_controller.rb 수정하기
>
>```ruby
>def update_comment
>  @comment = Comment.find(params[:comment_id])
>  @comment.update(content: params[:content])
>end
>```
>
>4. update_comment.js.erb 수정하기
>
>```javascript
>alert('댓글 수정 완료')
>// 2. input 태그가 있는 부분을 다시 일반 td 태그로 변환
>$('.edit-comment').replaceWith(`<td class="comment" data-id="<%= @comment.id %>"><%= @comment.content %></td>`);
>// 3. 완료버튼 없애주기
>$('.update-comment').remove();
>```
>
>



### 2. 무한스크롤 만들기

>1. 데이터 추가하기
>
>```ruby
>$ rake db:drop
>
>User.create(email: "asd@asd.com", password: "1234", password_confirmation: "1234")
>1000.times do
>  Board.create(
>    title: Faker::Superhero.name,
>    contents: Faker::Lorem.paragraphs.join,
>    user_id: 1
>  )
>end
>
>$ rake db:migrate
>$ rake db:seed
>```
>
>2. board_controller.rb 수정하기
>
>```ruby
>def index
>  @boards = Board.order("created_at DESC").page(params[:page])
>end
>
>def page_scroll
>  @boards = Board.order("created_at DESC").page(params[:page])
>end
>```
>
>3. models -> board.rb 수정하기
>
>```ruby
># default 값은 25 인데 한 페이지당 글을 50개로 늘린다.
>paginates_per 50
>```
>
>4. index.html.erb 수정하기
>
>```erb
><tbody class="boards">
>  <% @boards.each do |board| %>
>    <tr class="board" data-id=" <%= board.id %> ">
>      <td><%= board.id %></td>
>      <td class="title"><%= board.title %></td>
>    </tr>
>  <% end %>
></tbody>
><script>
>  $(document).ready(function(){
>    var page_count = 2
>    $(document).on('scroll', function(){
>      // 1. 화면 최하단에 도착했을때
>      if ($(window).scrollTop() >= $(document).height() - $(window).height()){
>        console.log("제일 아래 도착했다 !");
>        // 2. 추가적인 40개의 element에 대한 요청을 보냄
>        $.ajax({
>          url: '/boards/page_scroll',
>          method: 'get',
>          data: {
>            page: page_count++
>          }
>        })
>       // 3. 요청해서 응답으로 받은 element를 최하단에 추가
>      }
>    })
>  })
></script>
>```
>
>- 브라우저창 끝 이벤트
>
>```erb
><script>
>  // 이미 지나가서 우리눈에 보이지 않는 부분
>  console.log("window.scrollTop()" + $(window).scrollTop());
>  // 문서 전체의 길이
>  console.log("document.height()" + $(document).height());
>  // 우리가 보는 화면의 높이
>  console.log("window.height()" + $(window).height());
>  // 브라우저 창 끝 = 문서 전체의 길이 - 우리가 보는 화면의 높이 
></script>
>```
>
>5. page_scorll.js.rb 수정하기
>
>```javascript
>alert('페이지 추가하셈');
>$('.boards').append(`
>  <% @boards.each do |board| %>
>    <tr class="board" data-id=" <%= board.id %> ">
>      <td><%= board.id %></td>
>      <td class="title"><%= board.title %></td>
>    </tr>
>  <% end %>
>`)
>```
>
>6. change_show.js 코드를 다시 index.html에 옮기기 !
>
>```erb
><script>
>  $(document).ready(function(){
>    // setInterval(function(){
>    //   alert("Hello");
>    // }, 3000);
>    $('.table').on('click', '.board', function() {
>      location.href = "/boards/" + $(this).data('id');
>    })
>    var page_count = 2
>    ...
></script>
>```
>
> 

### 3. 회원가입 시 eamil 체크 만들기

>1. signup.html.erb 수정하기
>
>```erb
><% content_for :script do %>
>  <script>
>    $(function(){
>      $('input[name=email]').on('change', function(){
>        var id = $(this).val()
>        $.ajax({
>          url: '/check_email',
>          method: 'post',
>          data: {
>            email: id
>          }
>        })
>      })
>    })
>  </script>
><% end %>
>```
>
>2. routes.rb 수정하기
>
>```ruby
>post '/check_email' => 'sessions#check_email'
>```
>
>3. sessions_controller.rb 수정하기
>
>```ruby
>def check_email
>  User.find_by(email: params[:email]).nil?
>end
>```
>
>4. check_email.js.erb 만들기
>
>```javascript
>if (<%= @tmp %> && "<%= @eamil %>" != ""){
>  // 해당 이메일로 가입한 유저가 없는 경우
>  alert("가입 가능한 이메일입니다.");
>  $('button[type=submit]').removeAttr('disabled');
>}
>else {
>  // 해당 이메일로 가입한 유저가 있는 경우
>  alert("가입 불가능한 이메일입니다.");
>  $('button[type=submit]').attr('disabled', 'disabled');
>}
>```
>
>



### 4. password와 password_confirmation이 서로 다를경우

>```javascript
>var email = false;
>var password = false;
>1. function validation() {}
>// email과 password가 모두 true인지 확인
>// 모두 true이면 button의 disabled를 삭제
>// 하나라도 틀리면 button의 disabled를 추가
>2. 우리가 만들어 놓은 on('change')의 결과로는 변수 email과 password를 true, 혹은 fasle 변경시킨 후에 validation()을 실행 시킨다.
>```
>
>1. signup.html.erb
>
>```erb
><% content_for :script do %>
>  <script>
>    var email = false;
>    var password = false;
>    $(function(){
>      .....
>      $('input[name=password]').on('change', function(){
>        var pwd = $(this).val();
>        console.log(pwd);
>        $('input[name=password_confirmation]').on('change', function validation(){
>          var pwd_confirmation = $(this).val();
>          if (pwd === pwd_confirmation){
>            password = true;
>            if (email && password){
>              $('button[type=submit]').removeAttr('disabled');
>            }
>          }
>          else{
>            $('button[type=submit]').attr('disabled', 'disabled');
>          }
>        })
>      })
>	</script>
><% end %>
>```
>
>

 

### 자바스크립트 함수 선언 방법

>1. 함수 선언
>
>```javascript
>$('input').on('change', function(){
>  // 이벤트 핸들러로 이름이 없는 함수가 들어가있는 경우
>})
>// 자바스크립에서 함수 선언하기
>// 자바스크립트 함수를 선언할 때에는 jqurey 코드인
>// $(function() {}) 이전에 선언해주는 것이 통상적
>1. function 함수명(매개변수){} // 함수 선언식
>// 선언하기 이전에도 사용할 수 있음
>2. var 함수명 = function(매개변수) () // 함수 표현식
>// 선언하기 이전에 사용하면 undefined error 발생 
>```

