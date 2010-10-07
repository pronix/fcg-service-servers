module FCG::Service
  class BookmarkApp < FCG::Service::Base
    include FCG::Rest
    rest :bookmark
  end
end