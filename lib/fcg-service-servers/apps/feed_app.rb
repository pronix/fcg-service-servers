module FCG::Service
  class FeedApp < FCG::Service::Base
    include FCG::Rest
    rest :feed
  end
end