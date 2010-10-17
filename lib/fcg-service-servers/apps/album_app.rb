module FCG::Service
  class AlbumApp < FCG::Service::Base
    include FCG::Rest
    restful
  end
end