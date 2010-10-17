module FCG::Service
  class PartyApp < FCG::Service::Base
    include FCG::Rest
    restful
  end
end