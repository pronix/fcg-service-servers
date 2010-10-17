module FCG::Service
  class PostApp < FCG::Service::Base
    include FCG::Rest
    restful
  end
end