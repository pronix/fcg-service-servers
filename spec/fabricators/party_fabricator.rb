next_week = Date.today + 7
Fabricator :party do
  next_date     next_week.slashed
  start_time    "10:00pm"
  end_time      "4:00am" 
  title         Faker::Lorem.words
  music         "Hip-Hop, R&B, and Reggae"
  description   Faker::Lorem.paragraphs(5)
  # venue_id      "4cf3475fff808d982a00001a"
  # user_id       "4c43475fff808d982a00001a"
end