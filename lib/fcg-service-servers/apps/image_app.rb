module FCG::Service
  class ImageApp < FCG::Service::Base
    include FCG::Rest
    restful
  end
end