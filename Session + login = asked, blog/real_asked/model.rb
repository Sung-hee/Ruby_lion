# need install dm-sqlite-adapter
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/asked.db")

class Question
  ##DataMapper 객체로 Question를 만들겠다.
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :question, Text
  property :created_at, DateTime
end

class User
  include DataMapper::Resource
  property :id, Serial
  property :email, String
  property :password, String
  property :is_admin, Boolean, :default => false
  property :created_at, DateTime
end

DataMapper.finalize

Question.auto_upgrade!
User.auto_upgrade!
