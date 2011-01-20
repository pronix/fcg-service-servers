module FCG::Service
  class SiteApp < FCG::Service::Base
    include FCG::Rest
    restful
  end
end