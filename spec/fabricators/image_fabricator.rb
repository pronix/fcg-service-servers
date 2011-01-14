Fabricator :image do
  user_id   "4c43475fff808d982a00001a"
  album_id  "5c43475eff808d982a00001b"
  caption   Faker::Lorem.words(6).join(" ")
  types     FCG_CONFIG.image.user
  urls      "http://localhost/images/test.png"
  sizes     1024
end