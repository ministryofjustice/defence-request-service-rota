# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


(1..5).each do |i|
  User.where(email: "lla#{i}@example.com").first_or_create!(
    email: "lla#{i}@example.com",
    password: "password",
    name: "LLA #{i}"
  )
end