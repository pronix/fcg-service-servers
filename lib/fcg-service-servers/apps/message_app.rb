module FCG::Service
  class MessageApp < FCG::Service::Base
    include FCG::Rest
    restful
  end
end