Fabricator :message do
  sender_id             { new_id }
  receiver_id           { new_id }
  body                  Faker::Lorem.paragraph(2)
end