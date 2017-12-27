# Watcha clone app
# fake 왓챠 based on rails

# 0. 영화정보(Movie -> 직접)
# => model : Movie(title, poster, main_genre, nation, director)
# => controller : movies
# => movies#index (모든 영화를 보여주는 root page)
# => movies#show (하나의 영화를 보여주는 page)
# => 관리자 : CRUD

# 1. 영화 평점 주기
# => 로그인 된 유저 : 점수를 줄 수 있다, 리뷰도 달 수 있다.
# => 평점 - rating: integer, 리뷰 - comment: string, user_id, movie_id
# => Movie has_many :reviews
# => Review belongs_to :moive
# => User has_many :reviews
# => Review belongs_to :user

# 2. 게시판(Post -> Scaffold)
# => title:string, content:text, user_id:integer
# => User has_many :posts
# => Post belongs_to :user
# => 로그인 안된 유저 : R
# => 로그인 된 유저 : CRUD(본인의 글)
# => 관리자는 깡패라서 CRUD(모든 글)
# => 댓글(Comment)

# 3. 유저(User -> Devise)
# => signup, login, ... (o)
# => 관리자 / 일반유저 (o)
# => 한글버전
# => view 수정 가능
