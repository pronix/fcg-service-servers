Fabricator :rsvp do
  name              "Hailey Salley"
  number_of_guests  4
end

Fabricator :rsvp2, :from => :rsvp do
  name              "John Starks"
  number_of_guests  12
  message           Faker::Lorem.sentences(12).join(". ")
end