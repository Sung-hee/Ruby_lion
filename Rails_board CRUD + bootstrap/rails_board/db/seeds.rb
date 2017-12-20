# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# 일정한 데이터들을 입력하여 씨앗으로 삼고 사용할 수 있다.
Faker::Config.locale = 'ko'

User.create([
  { email: "asdf@asdf.com", password: "123" },
  { email: "qwer@qwer.com", password: "123" },
  { email: "zxcv@zxcv.com", password: "123" }
])

5.times do
  Post.create(
    title: Faker::Address.state,
    content: Faker::Lorem.words,
    user_id: rand(1..3)
  )
end

10.times do
  Comment.create(
    user_id: rand(1..3),
    post_id: rand(1..5),
    content: Faker::OnePiece.character
  )
end
