module FCG::Service
  class StatusApp < FCG::Service::Base
    include FCG::Rest
    restful :only => [:get, :post, :delete]
  end
end