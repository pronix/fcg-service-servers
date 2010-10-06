module FCG::Service
  class PartyApp < FCG::Service::Base
    include FCG::Rest
    rest :party
  end
end