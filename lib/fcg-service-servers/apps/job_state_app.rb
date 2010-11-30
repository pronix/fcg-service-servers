module FCG::Service
  class JobStateApp < FCG::Service::Base
    include FCG::Rest
    restful
  end
end