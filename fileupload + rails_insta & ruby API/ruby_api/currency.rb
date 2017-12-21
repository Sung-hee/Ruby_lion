require 'eu_central_bank'

@bank = EuCentralBank.new

# from = 'USD'
# to = 'KRW'
#
# result = bank.exchange(from, to)

def exchange(from)
  # 실시간으로 패치에서 정보를 받아옴
  @bank.update_rates
  @bank.exchange(100, from, 'KRW')
end

puts "$1 => #{exchange('USD')}원"
