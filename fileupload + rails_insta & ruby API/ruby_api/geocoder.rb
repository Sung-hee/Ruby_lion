require 'geocoder'

print '어디가 궁금하세요? :'
input = gets.chomp
loCord = Geocoder.coordinates('input')
p loCord
