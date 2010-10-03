module FCG::Service
  class PartyApp < FCG::Service::Base
    FCG::Rest.restful :party, self
  end
end