student = {
  # :name => "john",
  # :age => 19,
  # :gender => "male"
  name: "john",
  age: 19,
  gender: "male",
  # school: ["PFLHS", "YONSEI", "KAIST"]
  school: {
    highschool: ["daeingo", "German"],
    college: ["youngdong", "SW"],
    graduate: ["KAIST", "CS"]
  }
}

puts student[:age]
puts student[:gender]
puts student[:school][:graduate][0]
