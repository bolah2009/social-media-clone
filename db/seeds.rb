# frozen_string_literal: true

User.create!(name: 'Bola Ahmed',
             email: 'bola@example.com',
             password: 'password',
             password_confirmation: 'password')

User.create!(name: 'Sérgio Torres',
             email: 'torres@example.com',
             password: 'password',
             password_confirmation: 'password')

10.times do |n|
  name = Faker::Name.name
  email = "user-#{n + 1}@example.com"
  password = 'password'
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end

# Post
users = User.order(:created_at).take(10)
5.times do
  content = Faker::Lorem.sentence(word_count: 10)
  users.each { |user| user.posts.create!(content: content) }
end

# Comments and likes
users = User.all
posts = Post.all
like_posts = posts[1..30]
like_users = users[1..10]
comment_posts = posts[10..40]
comment_users = users[1..10]

like_posts.each do |post|
  like_users.each { |user| user.likes_given.create!(post_id: post.id) }
end

comment_posts.each do |post|
  content = Faker::Lorem.sentence(word_count: 5)
  comment_users.each { |user| user.comments.create!(post_id: post.id, content: content) }
end
