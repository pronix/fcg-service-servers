Fabricator :pauld, :from => :user do
  username "paulD"
  email   Faker::Internet.email
  password "strongpass"
  names { { :first => Faker::Name.first_name, :last  => Faker::Name.last_name } }
end

Fabricator :bryan, :from => :user do
  username "bryan"
  email   "bigsmyG@aol.com"
  password "whatever"
  names { { :first => Faker::Name.first_name, :last  => Faker::Name.last_name } }
  bio "Always running 1500 meter dash!"
end