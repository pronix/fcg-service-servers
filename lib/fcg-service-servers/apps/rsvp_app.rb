module FCG::Service
  class RsvpApp < FCG::Service::Base
    include FCG::Rest
    rest :rsvp
  end
end