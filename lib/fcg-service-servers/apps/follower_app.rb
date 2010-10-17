module FCG::Service
  class FollowerApp < FCG::Service::Base
    include FCG::Rest
    restful
  end
end