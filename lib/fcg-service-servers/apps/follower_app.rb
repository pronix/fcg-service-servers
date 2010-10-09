module FCG::Service
  class FollowerApp < FCG::Service::Base
    include FCG::Rest
    rest :follower
  end
end