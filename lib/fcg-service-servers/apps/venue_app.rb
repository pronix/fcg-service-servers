module FCG::Service
  class VenueApp < FCG::Service::Base
    # get a venue by id
    get "/api/#{API_VERSION}/venues/:id" do
      venue = Venue.find(params[:id]) rescue nil
      if venue and !venue.destroyed?
        venue.to_json
      else
        error 404, "venue not found".to_json
      end
    end

    # create a new venue
    post "/api/#{API_VERSION}/venues" do
      begin
        params = JSON.parse(request.body.read)
        venue = Venue.new(params)
        if venue.valid? and venue.save
          venue.to_json
        else
          error 400, error_hash(venue, "failed validation").to_json
        end
      rescue => e
        error 400, e.message.to_json
      end
    end

    # update an existing venue
    put "/api/#{API_VERSION}/venues/:id" do
      venue = Venue.find(params[:id])
      if venue and !venue.destroyed?
        begin
          venue.update_attributes(JSON.parse(request.body.read))
          if venue.valid?
            venue.to_json
          else
            error 400, error_hash(venue, "failed validation").to_json # do nothing for now. we'll cover later
          end
        rescue => e
          error 400, e.message.to_json
        end
      else
        error 404, "venue not found".to_json
      end
    end

    # destroy an existing venue
    delete "/api/#{API_VERSION}/venues/:id" do
      venue = Venue.find(params[:id])
      if venue and !venue.destroyed?
        venue.destroy
        venue.to_json
      else
        error 404, "venue not found".to_json
      end
    end
  end
end