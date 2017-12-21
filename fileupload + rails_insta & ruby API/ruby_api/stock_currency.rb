require 'eu_central_bank'
require 'stock_quote'

@bank = EuCentralBank.new

# from = 'USD'
# to = 'KRW'
#
# result = bank.exchange(from, to)

def usd_to_krw(volume)
  # 실시간으로 패치에서 정보를 받아옴
  @bank.update_rates
  rate = @bank.exchange(100, 'USD', 'KRW').to_f

  result = (volume.to_f * rate).round(2)

end

DATA.each do |company|
  company.chomp!
  stock = StockQuote::Stock.quote(company)

  puts stock.name
  puts "#{stock.l} (#{usd_to_krw(stock.l)})"
end

__END__
AAPL
FB
TSLA
GOOGL
AMZN
