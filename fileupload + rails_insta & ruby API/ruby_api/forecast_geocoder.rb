require 'geocoder'
require 'forecast_io'

ForecastIO.configure do |configuration|
    configuration.api_key = 'b08b5d7f3d6a0704568c7c0e69a745f0'
end

def f_to_c(f)
    f = f.to_f
    ((f - 32) * 5 / 9 ).round(2)
end

print '어디가 궁금하세요? :'
input = gets.chomp

loCord = Geocoder.coordinates(input)
forecast = ForecastIO.forecast(loCord.first, loCord.last)
f = forecast.currently

puts "#{input}의 현재 날씨는 #{f.summary} 며, 섭씨 #{f_to_c f.temperature}도 입니다."
