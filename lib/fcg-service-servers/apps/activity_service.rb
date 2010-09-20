module FCG
  class ActivityService < Service::Base
    # get an activity stream by id
    get "/api/#{API_VERSION}/activities/:id" do
      activity = Activity.find(params[:id]) rescue nil
      if activity
        activity.to_json
      else
        error 404, "activity not found".to_json
      end
    end

    # create a new activity
    post "/api/#{API_VERSION}/activities" do
      begin
        params = JSON.parse(request.body.read)
        activity = Activity.new(params)
        if activity.valid? and activity.save
          activity.to_json
        else
          error 400, error_hash(activity, "failed validation").to_json
        end
      rescue => e
        error 400, e.message.to_json
      end
    end

    # destroy an existing activity
    delete "/api/#{API_VERSION}/activities/:id" do
      activity = Activity.find(params[:id])
      if activity
        activity.destroy
        activity.to_json
      else
        error 404, "activity not found".to_json
      end
    end
  end
end