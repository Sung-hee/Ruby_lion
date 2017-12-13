def hello
  puts "hello"
  yield
  puts "welcome"
end

hello do
  puts "hee"
  puts "Today I'am cold"
end
