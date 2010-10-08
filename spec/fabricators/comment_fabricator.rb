text = "#{Faker::Lorem.paragraphs(5)}" + " From http://www.alltheparties.com"
Fabricator :comment do
  site            "alltheparties.com"
  record   "feed:4c43475fff808d982a00001a"
  body            text
  displayed_name  "Sammy Davis Jr."
  user_id         "4c43475fdf808f982a00001a"
end