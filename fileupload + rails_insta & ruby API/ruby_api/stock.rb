require 'stock_quote'

DATA.each do |company|
  stock = StockQuote::Stock.quote(company)

  company.chomp!
end

# 파일이 끝났다라고 인식함 END 밑으로는 루비코드가 아니라고 인식함
# 아래는 전부 DATA 처리
__END__
AAPL
FB
TSLA
GOOGL
AMZN
