module FCG::Service
  class UserApp < FCG::Service::Base
    include FCG::Rest
    rest :user
    
    # get a user by email
    get "/api/#{API_VERSION}/users/find_by_:field/:value" do
      user = User.first(:conditions => { params[:field].to_sym => params[:value] })
      if user and !user.destroyed?
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
        if user and !user.destroyed? and user.authenticated?(attributes["password"])
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