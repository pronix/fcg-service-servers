module FCG::Service
  class BaseApp < FCG::Service::Base
    get "/status" do
      respond_with({:state =>"running", :time => Time.now.utc.to_s, })
    end
    
    get "/sites" do
      sites = Site.all.map
      respond_with(sites)
    end
  end
end