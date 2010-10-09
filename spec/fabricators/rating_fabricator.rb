Fabricator :rating do
  record        'post:4c43475fffefad982a00001a'
  user_id       "4c43475fff808d982a00001a"
  score         4
end

1.upto(25) do |i|
  user_id = rand(23602195835208247086376026138).to_s(16)
  score   = rand(5) + 1
  Fabricator "rating_#{i}".to_sym, :from => :rating do
    record        "post:4c43475fffefad982a00001a"
    user_id       "#{user_id}"
    score         { score }
  end
end