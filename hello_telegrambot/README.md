## 멋쟁이사자처럼 프로젝트 실습 7일차

#### 오늘은 내일이 시험이라 실습은 없습니다 !



### 대신에 복습 겸 심심해서 혼자 인사챗봇 만들어봤습니다. 

>  텍스트에 인사말이 입력이 되면 챗봇으로 인사말을 내보내는 챗봇 !
>  내일 시험인데 시험공부해야되는데  조금만 할려했는데  두시간을 써버렸다.. 
>
> ```ruby
> require 'httparty'
> require 'awesome_print'
> require 'json'
> require 'uri'
> require 'nokogiri'
>
> url = "https://api.telegram.org/bot"
> token = "494505815:AAEr9hM4tekek6fYfA03-6n7emUC5vdbjcE"
> response = HTTParty.get("#{url}#{token}/getUpdates")
> hash = JSON.parse(response.body)
>
> hi_text = ["ㅎㅇ", "안녕", "hi", "반가워", "하이"]
> end_text = "종료"
> chat_update = hash["result"].last["update_id"]
>
> while true
>   # 여기서 리프래쉬 해줘야 한다.
>   # 안하면 update_id.last 가 업데이트가 안되서 
>   # update_id의 인덱스가 변하지 않아 if문이 성립이 안되고
>   # 무한루프에 빠지게 된다...
>   response = HTTParty.get("#{url}#{token}/getUpdates")
>   hash = JSON.parse(response.body)
>
>   new_update = hash["result"].last["update_id"]
>
>   if new_update > chat_update
>     # pooling 방법
>     chat_text = hash["result"].last["message"]["text"]
>     chat_id = hash["result"].last["message"]["from"]["id"]
>
>     hi_text.each do |index|
>       if index == chat_text
>
>          msg = "안녕하세요"
>          encoded = URI.encode(msg)
>
>          HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded}")
>       end
>     end
>     chat_update = new_update
>   elsif hash["result"].last["message"]["text"] == end_text
>     msg_end = "종료합니다"
>     encoded_end = URI.encode(msg_end)
>
>     HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded_end}")
>     puts "종료합니다"
>     break
>   end
> end
>
> ```
>
>  

#### 오늘은 이만 ! 

