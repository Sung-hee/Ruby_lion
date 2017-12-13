# need install dm-sqlite-adapter
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")

class Post
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :body, Text
  property :created_at, DateTime
end

# 유저 저장 DB
class User
  include DataMapper::Resource
  property :id, Serial
  property :email, String
  property :password, Text
  # 관리자인지 아닌지를 체크하기 위해서 is_admin 추가
  property :is_admin, Boolean, :default => false
  property :created_at, DateTime
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
Post.auto_upgrade!
User.auto_upgrade!
