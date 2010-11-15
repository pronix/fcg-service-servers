module FCG::Service
  class CommentApp < FCG::Service::Base
    include FCG::Rest
    restful :search => true
  end
end