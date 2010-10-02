module FCG::Service
  class EventApp < FCG::Service::Base
    # get a event by id
    get "/api/#{API_VERSION}/events/:id" do
      event = Event.find(params[:id]) rescue nil
      if event and !event.destroyed?
        event.to_json
      else
        error 404, "event not found".to_json
      end
    end

    # create a new event
    post "/api/#{API_VERSION}/events" do
      begin
        params = Hashie::Mash.new(JSON.parse(request.body.read))
        event = Event.new(params)
        if event.save
          event.to_json
        else
          error 400, error_hash(event, "failed validation").to_json
        end
      rescue => e
        error 400, e.message.to_json
      end
    end

    # update an existing event
    put "/api/#{API_VERSION}/events/:id" do
      event = Event.find(params[:id])
      if event and !event.destroyed?
        begin
          event.update_attributes(JSON.parse(request.body.read))
          if event.valid?
            event.to_json
          else
            error 400, error_hash(event, "failed validation").to_json # do nothing for now. we'll cover later
          end
        rescue => e
          error 400, e.message.to_json
        end
      else
        error 404, "event not found".to_json
      end
    end

    # destroy an existing event
    delete "/api/#{API_VERSION}/events/:id" do
      event = Event.find(params[:id])
      if event and !event.destroyed?
        event.destroy
        event.to_json
      else
        error 404, "event not found".to_json
      end
    end
  end
end