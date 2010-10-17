module FCG::Service
  class ActivityApp < FCG::Service::Base
    # get an activity stream by id
    get "/activities/:id" do
      activity = Activity.find(params[:id]) rescue nil
      if activity
        activity.to_msgpack
      else
        error 404, "activity not found".to_msgpack
      end
    end

    # create a new activity
    post "/activities" do
      begin
        params = MessagePack.unpack(request.body.read)
        activity = Activity.new(params)
        if activity.valid? and activity.save
          activity.to_msgpack
        else
          error 400, error_hash(activity, "failed validation").to_msgpack
        end
      rescue => e
        error 400, e.message.to_msgpack
      end
    end

    # destroy an existing activity
    delete "/activities/:id" do
      activity = Activity.find(params[:id])
      if activity
        activity.destroy
        activity.to_msgpack
      else
        error 404, "activity not found".to_msgpack
      end
    end
  end
end