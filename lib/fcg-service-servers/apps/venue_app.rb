module FCG::Service
  class VenueApp < FCG::Service::Base
    FCG::Rest.restful :venue, self
  end
end