# 30.times do
#   User.create!(
#       name: Faker::Name.unique.name,
#       email: Faker::Internet.email,
#       password: 'password',
#       password_confirmation: 'password'
#   )
# end

# 30.times do |index|
#   Post.create!(
#       user: User.offset(rand(User.count)).first,
#       mountain: Mountain.offset(rand(Mountain.count)).first,
#       title: "タイトル#{index}",
#       body: "本文#{index}"
#   )
# end