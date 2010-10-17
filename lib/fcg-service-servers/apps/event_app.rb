module FCG::Service
  class EventApp < FCG::Service::Base
    include FCG::Rest
    restful :search => true
  end
end