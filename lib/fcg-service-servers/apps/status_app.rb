module FCG::Service
  class StatusApp < FCG::Service::Base
    include FCG::Rest
    rest :status, :only => [:get, :post, :delete]
  end
end