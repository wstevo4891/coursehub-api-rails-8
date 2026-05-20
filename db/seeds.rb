# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Seeding database..."

User.find_or_create_by(email: "admin@example.com") do |user|
  user.name = "Admin User",
  user.password = "SecurePassword123",
  user.is_admin = true
end

puts "Created Admin User."

puts "Creating 10 sample users..."

10.times do
  User.find_or_create_by(email: Faker::Internet.email) do |user|
    user.name = Faker::Name.name
    user.password = "password"
    user.is_admin = false
  end
end

puts "Sample users are in place."

puts "Creating courses..."

Course.find_or_create_by(title: "Rails API") do |course|
  course.description = "Learn to build an API in Ruby on Rails."
  course.status = "draft"
end

Course.find_or_create_by(title: "Rails with MongoDB") do |course|
  course.description = "Learn how to build a NoSQL database in Rails with MongoDB."
  course.status = "draft"
end

Course.find_or_create_by(title: "Rails with GraphQL") do |course|
  course.description = "Learn how to build a GraphQL API in Rails."
  course.status = "draft"
end

puts "Courses created."

puts "Finished seeding."
