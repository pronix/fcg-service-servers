module FCG
  class UserService < Service::Base
    # get a user by email
    get "/api/#{API_VERSION}/users/find_by_:field/:value" do
      user = User.send("find_by_#{params[:field]}", params[:value])
      if user and !user.deleted?
        user.to_json
      else
        error 404, "user not found".to_json
      end
    end
      
    # get a user by id
    get "/api/#{API_VERSION}/users/:id" do
      user = User.find(params[:id]) rescue nil
      if user and !user.deleted?
        user.to_json
      else
        error 404, "user not found".to_json
      end
    end

    # create a new user
    post "/api/#{API_VERSION}/users" do
      begin
        params = JSON.parse(request.body.read)
        user = User.new(params)
        if user.valid? and user.save
          user.to_json
        else
          error 400, error_hash(user, "failed validation").to_json
        end
      rescue => e
        error 400, e.message.to_json
      end
    end

    # update an existing user
    put "/api/#{API_VERSION}/users/:id" do
      user = User.find(params[:id])
      if user and !user.deleted?
        begin
          user.update_attributes(JSON.parse(request.body.read))
          if user.valid?
            user.to_json
          else
            error 400, error_hash(user, "failed validation").to_json # do nothing for now. we'll cover later
          end
        rescue => e
          error 400, e.message.to_json
        end
      else
        error 404, "user not found".to_json
      end
    end

    # destroy an existing user
    delete "/api/#{API_VERSION}/users/:id" do
      user = User.find(params[:id])
      if user and !user.deleted?
        user.destroy
        user.to_json
      else
        error 404, "user not found".to_json
      end
    end

    # verify a user name and password
    post "/api/#{API_VERSION}/users/:id/sessions" do
      begin
        attributes = JSON.parse(request.body.read)
        user = User.find(params[:id])
        if user and !user.deleted? and user.authenticated?(attributes["password"])
          user.to_json
        else
          error 400, "invalid login credentials".to_json
        end
      rescue => e
        error 400, e.message.to_json
      end
    end
  end
end