Fabricator :user do
  username    Faker::Internet.user_name
  email       Faker::Internet.email
  password    Faker::Lorem.words(2)
  first_name  Faker::Name.first_name
  last_name   Faker::Name.last_name
  bio         Faker::Lorem.paragraphs(2)
end

Fabricator :pauld, :from => :user do
  username "paulD"
  email   Faker::Internet.email
  password "strongpass"
  first_name  Faker::Name.first_name
  last_name   Faker::Name.last_name
end

Fabricator :bryan, :from => :user do
  username "bryan"
  email   "bigsmyG@aol.com"
  password "whatever"
  first_name  Faker::Name.first_name
  last_name   Faker::Name.last_name
  bio "Always running 1500 meter dash!"
end

Fabricator :sam, :from => :user do
  username "joemocha"
  email   "onyekwelu@obukwelu.com"
  password "laslas"
end