module FCG::Service
  class RatingApp < FCG::Service::Base
    include FCG::Rest
    rest :rating
  end
end