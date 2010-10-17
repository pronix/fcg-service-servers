module FCG::Service
  class RsvpApp < FCG::Service::Base
    include FCG::Rest
    restful
  end
end