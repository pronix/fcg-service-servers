Fabricator :tomorrow_event, :from => :event do
  date Date.today.slashed
  start_time "10:00pm"
  end_time "4:00am"
  user_id "4c43475fff808d982a00001a" 
  party_id "4f43475fff808d982a00001a"
  venue do
    {
      :name      => "#{Faker::Company.name} Lounge",
      :address   => Faker::Address.street_address,
      :country   => "US",
      :citycode  => "nyc",
      :zipcode   => Faker::Address.zip_code,
      :user_id   => "4c43475fff808d982a00001a",
      :_id       => "4cf3475fff808d982a00001a" 
    }
  end
end