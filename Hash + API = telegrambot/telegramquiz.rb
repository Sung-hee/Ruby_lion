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

hash = {
  conv: ["코끼리를 냉장고에 넣는 방법은?", "냉장고 문을 열고 코끼리를 넣고 문을 닫는다.", "그러면 기린을 냉장고에 넣는 방법은?", "냉장고 문을 열고, 코끼리를 꺼낸 뒤, 기린을 넣는다.",
  "사자가 모든 동물들이 참가하는 동물회의를 열었는데, 한 동물이 결석했다. 빠진 동물은?", "기린. 아직 냉장고에 있다.", "악어가 득실거려 들어가면 위험한 강을 건너려고 한다. 건너갈 수 있는 배도 없다. 어떻게 건너가면 될까?", "그냥 헤엄쳐서 건넌다. 악어들은 모두 동물회의에 갔다.",
  "회의 중 사자가 목이 말라 음료수를 가져오라 했는데 누구한테 심부름을 시키는게 가장 효율적일까?", "기린에게 냉장고에서 나오면서 음료수를 가져오라 하면 된다."],
}
run = "true"
while run
  10.times do |n|
  chat_msg = hash[:conv]["#{n}".to_i]

  encoded_msg = URI.encode(chat_msg)

  HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded_msg}")

  sleep(3)
  end
  n = 9
  run = "false"
end
