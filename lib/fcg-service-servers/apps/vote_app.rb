module FCG::Service
  class VoteApp < FCG::Service::Base
    include FCG::Rest
    rest :vote, :only => [:post, :delete]
  end
end