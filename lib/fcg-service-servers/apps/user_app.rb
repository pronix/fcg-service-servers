module FCG::Service
  class UserApp < FCG::Service::Base
    include FCG::Rest
    restful
    
    # get a user by email
    get "/users/find_by_:field/:value" do
      user = User.first(:conditions => { params[:field].to_sym => params[:value] })
      if user and !user.destroyed?
        user.to_msgpack
      else
        error 404, "user not found".to_msgpack
      end
    end

    # verify a user name and password
    post "/users/:id/sessions" do
      begin
        attributes = MessagePack.unpack(request.body.read)
        user = User.find(params[:id])
        if user and !user.destroyed? and user.authenticated?(attributes["password"])
          user.to_msgpack
        else
          error 400, "invalid login credentials".to_msgpack
        end
      rescue => e
        error 400, e.message.to_msgpack
      end
    end
  end
end