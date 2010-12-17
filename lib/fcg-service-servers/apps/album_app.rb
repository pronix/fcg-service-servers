module FCG::Service
  class AlbumApp < FCG::Service::Base
    include FCG::Rest
    restful :search => true
    
    get "/albums/citycode/:citycode" do
      begin
        results = Album.by_citycode(params[:citycode]).limit(params[:limit].to_i || 10).skip(params[:skip].to_i || 0)
        if params[:active] == "true"
          results.active
        else
          results.inactive 
        end
        
        case params[:state]
        when "future"
          time = Time.parse(params[:time]) || Time.now.utc
          results.future(time)
        when "past"
          time = Time.parse(params[:time]) || Time.now.utc
          results.past(time)
        when "between"
          start_time, end_time = params[:time].split("..").map{|t| Time.parse(t) }
          results.by_range(start_time..end_time)
        end
        
        if results.size > 0
          respond_with(results.map(&:to_hash))
        else
          respond_with([])
        end
      rescue BSON::InvalidObjectId => e
        LOGGER.error "\#{e.backtrace}: \#{e.message} (\#{e.class})"
        error 404, respond_with("Events not found")
      end
    end
  end
end