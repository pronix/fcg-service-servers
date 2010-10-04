module FCG::Service
  class VenueApp < FCG::Service::Base
    include FCG::Rest
    rest :venue
  end
end