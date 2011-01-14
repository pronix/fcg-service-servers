module FCG::Service
  class ImageApp < FCG::Service::Base
    include FCG::Rest
    
    get "/images/by_ids/:ids" do
      begin
        ids = params[:ids].split(",")
        results = Image.find(ids)
        if results.size > 0
          respond_with(results.map(&:to_hash))
        else
          respond_with([])
        end
      rescue BSON::InvalidObjectId => e
        LOGGER.error "\#{e.backtrace}: \#{e.message} (\#{e.class})"
        error 404, respond_with("Images not found")
      end
    end
    
    restful
  end
end