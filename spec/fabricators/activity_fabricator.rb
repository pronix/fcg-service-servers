Fabricator :activity do
  user_id     "4c43475fff808d982a00001a"
  verb        "click"
  object_type "events"
  target      "event detail"
  title       Faker::Lorem.words(3).join(" ")
  page        "/events"
  site        "alltheparties.com"
  city        "nyc"
end