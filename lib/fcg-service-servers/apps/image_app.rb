module FCG::Service
  class ImageApp < FCG::Service::Base
    include FCG::Rest
    rest :image
  end
end