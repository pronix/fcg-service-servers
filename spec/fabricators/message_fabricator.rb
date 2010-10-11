Fabricator :message do
  sender_id             { new_user_id }
  receiver_id           { new_user_id }
  body                  Faker::Lorem.paragraph(2)
end