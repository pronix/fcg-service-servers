Fabricator :post do
  site            "alltheparties.com"
  title           "this is the sample title"
  user_id         "4c43475fdf808f982a00001a"
  body            Faker::Lorem.sentences(5).to_s
  display_name    "Sammy Davis Jr."
  username        "sdj"
end