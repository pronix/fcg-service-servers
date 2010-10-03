module FCG::Service
  class EventApp < FCG::Service::Base
    FCG::Rest.restful :event, self
  end
end