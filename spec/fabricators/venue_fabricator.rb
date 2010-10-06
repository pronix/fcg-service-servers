Fabricator :bar, :from => :venue do
  name      "Aperitivo"
  address   "279 Fifth Avenue"
  country   "US"
  zipcode   "11215"
  user_id   "4c43475fff808d982a00001a"
end

Fabricator :lounge, :from => :venue do
  name      "#{Faker::Company.name} Lounge"
  address   Faker::Address.street_address
  country   "US"
  zipcode   '78745'
  user_id   "4c43475fff808d982a00001a"
end

Fabricator :venue do
  name      "#{Faker::Company.name} Lounge"
  address   Faker::Address.street_address
  country   "US"
  citycode  "nyc"
  zipcode   "10010"
  user_id   "4c43475fff808d982a00001a"
end