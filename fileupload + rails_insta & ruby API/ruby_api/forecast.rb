require 'forecast_io'

ForecastIO.configure do |configuration|
    configuration.api_key = 'b08b5d7f3d6a0704568c7c0e69a745f0'
end
forecast = ForecastIO.forecast(37.501554, 127.039703)
f = forecast.currently

def f_to_c(f)
    f = f.to_f
    ((f - 32) * 5 / 9 ).round(2)
end

puts f.temperature
puts f.summary
puts f_to_c f.temperature
