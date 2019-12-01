# Create main sample user
User.create!(name: "Clint Eastwood",
             email: "allen.matt@gmail.com",
             password: "abc123",
             password_confirmation: "abc123")
             
# Generate a bunch of additional users
99.times do |n|
  name     = Faker::Name.name
  email    = "example-#{n+1}@example.com"
  password = "abc123"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end