module FCG::Service
  class FeedApp < FCG::Service::Base
    include FCG::Rest
    restful
  end
end