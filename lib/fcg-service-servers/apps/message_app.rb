module FCG::Service
  class MessageApp < FCG::Service::Base
    include FCG::Rest
    rest :message
  end
end