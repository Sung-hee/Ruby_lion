require 'httparty'
require 'awesome_print'
require 'json'
require 'uri'
require 'nokogiri'

url = "https://api.telegram.org/bot"
token = "494505815:AAEr9hM4tekek6fYfA03-6n7emUC5vdbjcE"
response = HTTParty.get("#{url}#{token}/getUpdates")
hash = JSON.parse(response.body)

hi_text = ["ㅎㅇ", "안녕", "hi", "반가워", "하이"]
end_text = "종료"
chat_update = hash["result"].last["update_id"]

while true
  response = HTTParty.get("#{url}#{token}/getUpdates")
  hash = JSON.parse(response.body)

  new_update = hash["result"].last["update_id"]

  if new_update > chat_update
    # pooling 방법
    chat_text = hash["result"].last["message"]["text"]
    chat_id = hash["result"].last["message"]["from"]["id"]

    hi_text.each do |index|
      if index == chat_text

         msg = "안녕하세요"
         encoded = URI.encode(msg)

         HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded}")
      end
    end
    chat_update = new_update
  elsif hash["result"].last["message"]["text"] == end_text
    msg_end = "종료합니다"
    encoded_end = URI.encode(msg_end)

    HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded_end}")
    puts "종료합니다"
    break
  end
end
