module FCG::Service
  class VoteApp < FCG::Service::Base
    include FCG::Rest
    restful :only => [:post, :delete]
  end
end