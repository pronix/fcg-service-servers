module FCG::Service
  class EventApp < FCG::Service::Base
    include FCG::Rest
    rest :event
    # FCG::Rest.restful :event, self
  end
end