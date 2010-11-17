module FCG::Service
  class VenueApp < FCG::Service::Base
    include FCG::Rest
    
    get "/venues/autocomplete" do
      begin
        results = Venue.where(:name => /^(the|a)?(\s)?#{params[:term]}.*/i ).limit(20).limit(params[:limit].to_i || 10).skip(params[:skip].to_i || 0)
        if results.size > 0
          respond_with(results.map(&:to_hash))
        else
          respond_with([])
        end
      rescue BSON::InvalidObjectId => e
        LOGGER.error "\#{e.backtrace}: \#{e.message} (\#{e.class})"
        error 404, respond_with("Venue not found")
      end
    end
    
    restful
  end
end