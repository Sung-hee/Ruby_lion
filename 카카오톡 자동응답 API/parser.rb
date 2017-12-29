module Parser
  class Movie
    def naver
      url = "http://movie.naver.com/movie/running/current.nhn?view=list&tab=normal&order=reserve"
      movie_html = HTTParty.get(url)
      doc = Nokogiri::HTML(movie_html)

      movie_title = Array.new
      movie_info = Hash.new

      doc.css("ul.lst_detail_t1 dt a").each do |title|
        movie_title << title.text
      end

      doc.css("ul.lst_detail_t1 li").each do |movie|
        # movie_info 안에 movie.css("dl dt.tit a").text 이런 키가 있다.
        # 쉽게말하자면 "강철비 (키값)" => "{:url, :star}" 이런 구조임!
        movie_info[movie.css("dl dt.tit a").text] = {
          :url => movie.css("div.thumb img").attribute('src').to_s,
          :star => movie.css("dl.info_star span.num").text
        }
      end

      sample_movie = movie_title.sample
      return_text = sample_movie + " " + movie_info[sample_movie][:star]
      img_url = movie_info[sample_movie][:url]

      return [return_text, img_url]
    end
  end

  class Animal
    def cat
      return_text = "왜나만 고양이가 없어"
      # jpg 타입의 이미지만 가져올꺼야.
      url = "http://thecatapi.com/api/images/get?format=xml&type=jpg"
      cat_xml = HTTParty.get(url).body
      doc = Nokogiri::XML(cat_xml)
      img_url = doc.xpath("//url").text

      return [return_text, img_url]
    end
  end

  class Tottenham
    def tottenham_schedule
      return_text = "이번 토트넘 경기는"
      url 
    end
  end
end
