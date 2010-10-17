Fabricator :album do
  title         Faker::Lorem.words(12).join(" ")
  description   Faker::Lorem.sentences(3).join(" ")
  user_id       "4c43475fff808d982a00001a"
  date          { Date.today - 1 }
  record        { "user:#{new_id}" }
end