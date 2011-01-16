module FCG::Service
  class ActivityApp < FCG::Service::Base
    include FCG::Rest
    restful
  end
end