class Movie < ActiveRecord::Base
  has_many :reviews

  # 평점 평균 구하기
  def number
    # self는 객체 자신
    self.reviews.count
  end

  def avg
    sum = 0

    self.reviews.each do |r|
      sum += r.rating
    end

    if self.reviews.count == 0
      0
    else
      sum.to_f / self.reviews.count
    end
  end
end
