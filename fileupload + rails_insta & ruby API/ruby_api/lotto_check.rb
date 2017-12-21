# 오픈을 확장하여 uri까지 오픈할 수 있게 도와줌
require 'open-uri'
require 'json'

my_numbers = [1..45].to_a.sample(6)
# my_numbers = [*1..45].sample(6) 두개는 같은 문법

url = 'http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo='
page = open(url).read
info = JSON.parse(page)

# 1. 현재 info hash에 있는 값을 잘 해서 아래에 넣는다.
lucky_numbers = []

info.each do |key, value|
   lucky_numbers << value if key.include?('drwtNo')
   lucky_numbers.sort!
   # if key.include?('drwtNo')
   #    lucky_numbers = value
   # end
end

bouns_number = info['bnusNo']
# 2. lucky_numbers / bouns_number를 사용하여 우리가 뽑은 번호와 비교한다.
# => 1등 : 6개 숫자가 전부 맞을 경우
# => 2등 : 5개가 맞고 남은 한개가 보너스 번호일 경우
# => 3등 : 5개 맞을 때
# => 4등 : 4개 맞을 때
# => 5등 : 3개 맞을 때
# cnt = 0
#
# my_numbers.each do |my|
#    lucky_numbers.each do |lucky|
#       if my == lucky
#          cnt += 1
#       end
#    end
# end

# if cnt == 6
#    puts "1등"
# elsif cnt == 5 && my.my_numbers.include?(bouns_number)
#    puts "2등"
# elsif cnt == 5
#    puts "3등"
# elsif cnt == 4
#    puts "4등"
# elsif cnt == 3
#    puts "5등"
# else
#    puts "꽝"
# end

# 강사님 코드 !
# match_numbers
# match_count = match_numbers.count

match_numbers = lucky_numbers & my_numbers
match_count = match_numbers.count
# if match_count == 6 then puts "1등"
# elsif match_count == 5 && my.my_numbers.include? bouns_number then puts "2등"
# elsif match_count == 5 then puts "3등"
# elsif match_count == 4 then puts "4등"
# elsif match_count == 3 then puts "5등"
# else then puts "꽝"
# end

result =
   case [match_count, my_numbers.include?(bouns_number)]
      when [6, false] then '1등'
      when [5, true]  then '2등'
      when [5, false] then '3등'
      when [4, false] then '4등'
      when [3, false] then '5등'
      else '꽝'
   end

puts result
