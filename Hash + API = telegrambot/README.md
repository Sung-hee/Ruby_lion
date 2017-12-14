## 멋쟁이사자처럼 프로젝트 실습 6일차

### 1. 오늘도 시작은 복습으로 ! 그리고 실습환경은 Atom !

>#### 1. 게시판 만들기 !
>
>```ruby
># Board 만들기
># 1. get '/' {} : index.erb
># => 지금까지 써진 모든 글들을 보여준다.
># => '글쓰기' 링크가 있고 -> '/new'
># 2. get '/new' : new.erb
># => 새로운 글을 쓸 수 있는 <form>, title, content -> /'create'
># 3. get '/create' :
># => new에서 보내준 정보를 바탕으로 Post.create()
># => redirect -> '/'
># 4. 회원가입 '/signup'
># 5. 로그인 '/login'
>```
>
>- **app.rb  일부분**
>
>```ruby
>get '/create' do
>  Post.create(
>    :title => params["title"],
>    :content => params["content"],
>    :author => params["author"]
>  )
>
>  redirect to '/'
>end
>
>get '/register' do
>  User.create(
>    :email => params["email"],
>    :password => params["password"]
>  )
>end
>
>get '/login_session' do
>  @message = ""
>
>  if User.first(:email => params["email"])
>    if User.first(:email => params["email"]).password == params["password"]
>      session[:email] = params["email"]
>
>      redirect to '/'
>    else
>      @message = "비밀번호가 틀렸습니다."
>    end
>  else
>    @message = "해당하는 유저의 이메일이 없습니다."
>  end
>end
>```
>
>- model.rb
>
>```ruby
># need install dm-sqlite-adapter
>DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/board.db")
>
>class Post
>  ##DataMapper 객체로 Question를 만들겠다.
>  include DataMapper::Resource
>  property :id, Serial
>  property :title, String
>  property :content, Text
>  property :author, String, :default => "익명"
>  property :created_at, DateTime
>end
>
>class User
>  include DataMapper::Resource
>  property :id, Serial
>  property :email, String
>  property :password, String
>  property :created_at, DateTime
>end
>
>DataMapper.finalize
>
>Post.auto_upgrade!
>User.auto_upgrade!
>```
>
>- index.erb 
>
>```ruby
><body>
>  <% @list.each do |q|%>
>    <div class="card">
>      <div class="card-body">
>        <p>번호 : <%= q.id %></p>
>        <p>제목 : <%= q.title %></p>
>        <p>내용 : <%= q.content %></p>
>        <p>작성자 : <%= q.author %></p>
>        <p>작성시간 : <%= q.created_at %></p>
>        <a href="/destroy">[삭제]</a>
>      </div>
>    </div>
>  <% end %>
></body>
>```



### 2.  CRUD 에서 U, D 를 배워보자 !

>#### 1. datamapper destroy 하는 방법 !
>
>```ruby
>zoo = Zoo.get(5)
>zoo.destroy  # => true
>```
>
>**그런데 input으로 값을 받아온게 아닌데 !!!! 어떻게 get() 으로 지우고 싶은 글을 가져올 수 있을까 ?**
>
>#### 어떻게 하느냐 ! variable routing 을 이용해서 임시변수를 만들면 된다 !
>
>```ruby
># variable routing
># hello 뒤에 아무 글자들이 들어와도
># hello 페이지로 보낸다.
># 즉, 임의의 변수를 만들어주고
># 입력된 어떠한 값들을 받아 임시 변수로 만들어 사용할 수 있게끔 만들어줌.
>get '/hello/:name' do
>  @name = params[:name]
>
>  erb :hello
>end
># # /sqaure/3을 넣으면
># # sqare.erb 보내주고, 3 * 3 = 9 을 출력
>get '/square/:num' do
>  num = params[:num].to_i
>  # @result = num * num
>  @result = num ** 2
>  erb :square
>end
>
>get '/cube/:num' do
>
>end
>```
>
>#### 2. 그러면 get '/destroy/:id'를 만들어보자
>
>```ruby
>get '/destroy/:id' do
>  # 1번 글을 지우게 될거면
>  # '/destroy/1...5'
>  post = Post.get(params[:id])
>  post.destroy
>
>  redirect to '/'
>end
>```
>
>#### 3. 그러면 이제는 update를 배워보자
>
>- 수정은 폼이 두개가 필요하다 !
>- 먼저 edit으로 정보를 가져온 후 글을 수정한다 ! 이후 update를 통해 수정 된 정보들을 저장한다.
>
>```ruby
>get '/edit/:id' do
>  # 수정하기 위해선
>  # 수정하고 싶은 정보가 edit에 넘어와야 한다 !
>  # 그러니 여기에서도 variable routing을 이용한다.
>  @post = Post.get(params[:id])
>
>  erb :edit
>end
>
>get '/update/:id' do
>  post = Post.get(params[:id])
>  post.update(
>    # :title => params["title"], 이렇게 해두 됨ㅋ
>    :title => params[:title],
>    :content => params[:content]
>  )
>
>  redirect to '/'
>end
>```
>
>- edit.erb
>
>```erb
><body>
>  <h1>수정하기</h1>
>  <form action="/update/<%= @post.id %>">
>      <div class="form-group col-md-4">
>        <input type="text" class="form-control" name="title" value="<%= @post.title %>">
>        <input type="text" class="form-control" name="content" value="<%= @post.content %>">
>        <input type="hidden" name="author" value="">
>      </div>
>      <button type="submit" class="btn btn-primary">Submit</button>
>  </form>
></body>
>```



### 3. 심볼과 String의 차이

>즉, 심볼도 객체이며, 문자열도 객체입니다. 그러나 symbol은 변경이 불가능(immutable)한 객체입니다. 다시말해, 심볼은 한번 값이 assign 되고 나면 값을 변경하는 것이 불가능합니다. 그렇다고 해서 객체자체가 Java의 final 선언된 변수와 같이 덮어쓸 수도 없다는 의미는 아닙니다. Immutable 이란, 객체가 가지고 있는 값을 변경(change)할 수는 없지만 덮어쓰기(overwrite)할 수는 있다는 의미입니다. 
>
>문자열은 변경이 가능(mutable) 하기 때문에, 루비 인터프리터는 실제 해당 문자열이 어떤 값을 가지고 있는지 실행시점까지 알 수 가 없습니다. 이것은 다시말해, 우리가 보기에는 동일한 문자열도 서로 다른 메모리 공간을 차지하고 있어야 한다는 의미입니다.
>
>```ubuntu
>[1] pry(main)> :hello
>=> :hello
>[2] pry(main)> name ="john"
>=> "john"
>[3] pry(main)> "hello #{name}"
>=> "hello john"
>[4] pry(main)> name = :jonn
>=> :jonn
>[5] pry(main)> "hello #{name}"
>=> "hello jonn"
>[6] pry(main)> "jonn" == :jonn
>=> false
>[7] pry(main)> "jonn" == "jonn"
>=> true
>[8] pry(main)> :jonn == :jonn
>=> true
>#### 우리가 보기에는 동일한 문자열도 서로 다른 메모리 공간을 차지하고 있어야 한다는 의미입니다. 아래와 같이 문자열을 생성하고 문자열의 객체ID를 출력해보면 이를 확인할 수 있습니다.
>[11] pry(main)> "john".object_id
>=> 47037357059680
>[12] pry(main)> "john".object_id
>=> 47037356061040
>[13] pry(main)> "john".object_id
>=> 47037359909820
>[14] pry(main)> :john.object_id
>=> 1784348
>[15] pry(main)> :john.object_id
>=> 1784348
>#### 심볼은 immutable 하기 때문에 한번 heap 메모리상에 생성되고 나면 해당 심볼은 동일한 객체로 재사용이 가능(reusable)합니다.
>[19] pry(main)> hash ={}
>=> {}
>[20] pry(main)> hash[:key] = "value"
>=> "value"
>[21] pry(main)> hash["key"] = "value new"
>=> "value new"
>[22] pry(main)> "key" == :key
>=> false
>#
>[23] pry(main)> hash ={key: "value"}
>=> {:key=>"value"}
>[24] pry(main)> hash = {:key => "value"}
>=> {:key=>"value"}
># 이 두개는 똑같은 문법. 
>```
>
>좀더 자세히 설명하자면, 루비에서 심볼은 단순히 동일한 heap 메모리를 재사용할 뿐만 아니라, Symbol dictionary를 통해 관리됩니다. 아래와 같은 명령어를 irb에서 실행하면 현재 Symbol dictionary에 존재하는 심볼 목록을 확인할 수 있습니다.
>
># 결론
>
>루비에서 대부분의 경우 심볼을 문자열을 사용하는 경우보다 메모리 효율성이나 성능 측면에서 유리합니다. 이러한 이유로 hash의 키 등으로 문자열을 사용하는 것보다 심볼을 사용하는 것이 좋습니다.
>
>대부분의 루비 개발자들은 해시의 키로 심볼을 사용하는 것이 익숙하지만, 왜 그렇게 해야하는지, 문자열 대신 심볼을 사용하는 것이 어떤한 면에서 유리한지는 한번 기억해 두는 것이 좋습니다.



### 4. 텔레그램 봇 만들기

>### 1. 텔레그램 봇 만들기
>
>우선 Telegram Desktop을 다운받자 !
>
>Telegram bot은 telegram의 the Botfather를 통해 만들 수 있다.
>
>이후 접속 후 Telegram 검색창에 BotFather 검색 
>
>```telegeram
>BotFather를 실행 후 
>1. /newbot Heesk 입력 후 Heesk란 봇프로그램 만들기. 
>2. 이후 봇의 이름을 정해주자 => heees_bot 
>그러면 Telegram에서 봇 API의 토큰을 준다 !
>3. 봇에게 텍스트를 보낸 후 https://api.telegram.org/bot"토큰"/getUpdates을 통해 결과를 확인하자
>4. 봇으로 사용자에게 텍스트를 보내고 싶다면
>https://api.telegram.org/bot"토큰"/sendmessage?chat_id="사용자id"&text="텍스트"
>5. 결과값은 웹페이지에 json 형식으로 받아오는데 !
>   보기 편하고 싶다면 크롬 확장프로그램에 json viewer를 다운받아 보자 !
>6. 이것만 하면 됨...
>```
>
> 
>
>#### json에서 정보를 받아올래면 Hash를 잘 알아야 한다 !
>
>그러니 hash 연습을 해보자 !
>
>```ruby
>student = {
>  # :name => "john",
>  # :age => 19,
>  # :gender => "male"
>  name: "john",
>  age: 19,
>  gender: "male",
>  # school: ["PFLHS", "YONSEI", "KAIST"]
>  school: {
>    highschool: ["daeingo", "German"],
>    college: ["youngdong", "SW"],
>    graduate: ["KAIST", "CS"]
>  }
>}
>
>puts student[:age]
>puts student[:gender]
>puts student[:school][:graduate][0]
>
># 결과값
># 19
># male
># KAIST
>```
>
> 
>
>#### 2. 루비를 이용해서 5초마다 메세지를 보내주는 챗봇을 만들기 !
>
>```ruby
># 자동 텔레그렘 updates
>require 'httparty'
>require 'awesome_print' # puts와 비슷한 아이인데 좀 더 이쁘게 출력해준다 ! 출력할땐 ap 변수명
>require 'json' #json을 ruby의 hash로 변환해주는 아이 !
>require 'uri' #url 한글을 코딩해주는 아이 !
>
># API url
>url = "https://api.telegram.org/bot"
>#API 토큰 정보
>token = "bot API Key"
># json의 결과를 response에 저장해라!
>response = HTTParty.get("#{url}#{token}/getUpdates")
>#json으로 된 자료를 ruby의 hash로 변환 해줘
>hash = JSON.parse(response.body)
>
># 챗 아이디를 뽑아줘 !
>chat_id = hash["result"][0]["message"]["from"]["id"]
>
># 챗 아이디를 뽑은 걸 활용하여 유저에게 메세지를 보내줘 !
>msg = "얌마"
>
># 한글을 url로 코딩해줘 !
>encoded = URI.encode(msg)
># 밑에 코드는 그냥 한번 보낼 때
># HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded}")
>
># 이거는 반복해서 메세지를 보낼 때
># 5초마다 메세지를 보내줘 !
>while true
>  HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded}")
>  sleep(5)
>end
>```
>
> 
>
>#### 3. 이번에는 코스피 지수 및 로또 번호 알려주는 챗봇 만들기 !
>
>```ruby
># 자동 텔레그렘 updates
>require 'httparty'
>require 'awesome_print' # puts와 비슷한 아이인데 좀 더 이쁘게 출력해준다 ! 출력할땐 ap 변수명
>require 'json' #json을 ruby의 hash로 변환해주는 아이 !
>require 'uri' #url 한글을 코딩해주는 아이 !
>require 'nokogiri'
>
># API url
>url = "https://api.telegram.org/bot"
>#API 토큰 정보
>token = "bot API Key"
># json의 결과를 response에 저장해라!
>response = HTTParty.get("#{url}#{token}/getUpdates")
>#json으로 된 자료를 ruby의 hash로 변환 해줘
>hash = JSON.parse(response.body)
>
># 챗 아이디를 뽑아줘 !
>chat_id = hash["result"][0]["message"]["from"]["id"]
>
># 밑에 코드는 그냥 한번 보낼 때
># HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded}")
>
># 이거는 반복해서 메세지를 보낼 때
># 5초마다 메세지를 보내줘 !
># while true
>#   HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded}")
>#   sleep(5)
># end
>
># Kospi 지수 스크랩 챗봇
>res = HTTParty.get("http://finance.naver.com/sise/")
>html = Nokogiri::HTML(res.body)
>kosipi = html.css("#KOSPI_now").text
>
>msg = "오늘 코스피 지수는 #{kosipi}"
>encode = URI.encode(msg)
>
>HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encode}")
># 로또 API를 이용해서 번호 가져오기
>res_lotto = HTTParty.get("http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=784")
>hash_lotto = JSON.parse(res_lotto.body)
>
>lottoNum = []
>
>6.times do |n|
>  lottoNum << hash_lotto["drwtNo"+"#{n+1}"]
>end
>msg = "이번주 로또번호는 #{lottoNum}"
>encode = URI.encode(msg)
>
>HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encode}")
>
>```
>
> 
>
>#### 4. 번외편... 사람들 괴롭히는 아재개그 스팸 챗봇 만들기
>
>```ruby
># 자동 텔레그렘 updates
>require 'httparty'
>require 'awesome_print' # puts와 비슷한 아이인데 좀 더 이쁘게 출력해준다 ! 출력할땐 ap 변수명
>require 'json' #json을 ruby의 hash로 변환해주는 아이 !
>require 'uri' #url 한글을 코딩해주는 아이 !
>require 'nokogiri'
>
># API url
>url = "https://api.telegram.org/bot"
>#API 토큰 정보
>token = "bot API Key"
># json의 결과를 response에 저장
>response = HTTParty.get("#{url}#{token}/getUpdates")
>#json으로 된 자료를 ruby의 hash로 변환
>hash = JSON.parse(response.body)
>
># 챗 아이디를 뽑아줘 !
>chat_id = hash["result"][0]["message"]["from"]["id"]
>
># 굳이 해쉬 안써도 됨 ! 연습할려고 써봄 !
>hash = {
>  conv: ["코끼리를 냉장고에 넣는 방법은?", "냉장고 문을 열고 코끼리를 넣고 문을 닫는다.", "그러면 기린을 냉장고에 넣는 방법은?", "냉장고 문을 열고, 코끼리를 꺼낸 뒤, 기린을 넣는다.",
>  "사자가 모든 동물들이 참가하는 동물회의를 열었는데, 한 동물이 결석했다. 빠진 동물은?", "기린. 아직 냉장고에 있다.", "악어가 득실거려 들어가면 위험한 강을 건너려고 한다. 건너갈 수 있는 배도 없다. 어떻게 건너가면 될까?", "그냥 헤엄쳐서 건넌다. 악어들은 모두 동물회의에 갔다.",
>  "회의 중 사자가 목이 말라 음료수를 가져오라 했는데 누구한테 심부름을 시키는게 가장 효율적일까?", "기린에게 냉장고에서 나오면서 음료수를 가져오라 하면 된다."],
>}
>run = "true"
>while run
>  10.times do |n|
>  chat_msg = hash[:conv]["#{n}".to_i]
>
>  encoded_msg = URI.encode(chat_msg)
>
>  HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded_msg}")
>
>  sleep(3)
>  end
>  n = 9
>  run = "false"
>end
>```
>
>

