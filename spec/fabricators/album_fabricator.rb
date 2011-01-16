Fabricator :album do
  title         Faker::Lorem.words(12).join(" ")[0,99]
  #description   Faker::Lorem.sentences(3).join(" ")
  user_id       "4c43475fff808d982a00001a"
  date          { Date.today - 1 }
  record        { "event:#{new_id}" }
  image_type    "event"
  location_hash do {
    :citycode => "nyc"
  }
  end
end

Fabricator :album_template, :from => :album do
  title         Faker::Lorem.words(12).join(" ")
  #description   Faker::Lorem.sentences(3).join(" ")
  user_id       "4c43475fff808d982a00001a"
  date          { Date.today - 1 }
  record        { "event:#{new_id}" }
  image_type    "event"
end