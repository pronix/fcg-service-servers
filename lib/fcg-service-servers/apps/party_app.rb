module FCG::Service
  class PartyApp < FCG::Service::Base
    include FCG::Rest
    restful :search => true
  end
end