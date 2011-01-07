module FCG::Service
  class BookmarkApp < FCG::Service::Base
    include FCG::Rest
    restful :search => true, :count => true
  end
end