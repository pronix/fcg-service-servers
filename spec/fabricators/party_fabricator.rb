next_date = Date.send(:now) + 1
Fabricator :party do
  next_date     next_date.slashed
  start_time    "10:00pm"
  end_time      "4:00am" 
  title         Faker::Lorem.words
  music         "Hip-Hop, R&B, and Reggae"
  description   Faker::Lorem.paragraphs(5)
  # venue_id      "4cf3475fff808d982a00001a"
  # user_id       "4c43475fff808d982a00001a"
end

# venue do
#   {
#     :name      => "#{Faker::Company.name} Lounge",
#     :address   => Faker::Address.street_address,
#     :country   => "US",
#     :zipcode   => Faker::Address.zip_code,
#     :user_id   => "4c43475fff808d982a00001a",
#     :_id       => "4cf3475fff808d982a00001a" 
#   }
# end

# validates_presence_of :title, :music, :description
# validates_format_of :start_time, :with => /^(0?[1-9]|1[0-2]):(00|15|30|45)(a|p)m$/i
# validates_format_of :end_time, :with => /^(0?[1-9]|1[0-2]):(00|15|30|45)(a|p)m$/i
# validates_length_of :title,   :within => 3..64
# validates_length_of :description,   :within => 3..5000