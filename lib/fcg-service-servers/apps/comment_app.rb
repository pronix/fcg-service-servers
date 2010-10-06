module FCG::Service
  class CommentApp < FCG::Service::Base
    include FCG::Rest
    rest :comment
  end
end