module FCG::Service
  class BaseApp < FCG::Service::Base
    get "/" do
      respond_with({:state =>"running", :time => Time.now.utc.to_s, })
    end
  end
end