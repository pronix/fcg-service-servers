module FCG::Service
  class EventApp < FCG::Service::Base
    include FCG::Rest
    restful
    # FCG::Rest.restful :event, self
  end
end