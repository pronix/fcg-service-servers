module FCG::Service
  class AlbumApp < FCG::Service::Base
    include FCG::Rest
    rest :album
  end
end