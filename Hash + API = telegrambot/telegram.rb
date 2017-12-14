# 자동 텔레그렘 updates
require 'httparty'
require 'awesome_print' # puts와 비슷한 아이인데 좀 더 이쁘게 출력해준다 ! 출력할땐 ap 변수명
require 'json' #json을 ruby의 hash로 변환해주는 아이 !
require 'uri' #url 한글을 코딩해주는 아이 !
require 'nokogiri'

# API url
url = "https://api.telegram.org/bot"
#API 토큰 정보
token = "494505815:AAEr9hM4tekek6fYfA03-6n7emUC5vdbjcE"
# json의 결과를 response에 저장해라!
response = HTTParty.get("#{url}#{token}/getUpdates")
#json으로 된 자료를 ruby의 hash로 변환 해줘
hash = JSON.parse(response.body)

# 챗 아이디를 뽑아줘 !
chat_id = hash["result"][0]["message"]["from"]["id"]

# 밑에 코드는 그냥 한번 보낼 때
# HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded}")

# 이거는 반복해서 메세지를 보낼 때
# 5초마다 메세지를 보내줘 !
# while true
#   HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded}")
#   sleep(5)
# end

# Kospi 지수 스크랩 챗봇
res = HTTParty.get("http://finance.naver.com/sise/")
html = Nokogiri::HTML(res.body)
kosipi = html.css("#KOSPI_now").text

msg = "오늘 코스피 지수는 #{kosipi}"
encode = URI.encode(msg)

HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encode}")
# 로또 API를 이용해서 번호 가져오기
res_lotto = HTTParty.get("http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=784")
hash_lotto = JSON.parse(res_lotto.body)

lottoNum = []

6.times do |n|
  lottoNum << hash_lotto["drwtNo#{n+1}"]
end

lucky = lottoNum.to_s
bonus = hash_lotto["bnusNo"]

msg = "이번주 로또번호는 #{lucky} 보너스번호 : #{bonus}"
encode = URI.encode(msg)

HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encode}")
