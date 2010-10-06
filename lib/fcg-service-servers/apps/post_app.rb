module FCG::Service
  class PostApp < FCG::Service::Base
    include FCG::Rest
    rest :post
  end
end