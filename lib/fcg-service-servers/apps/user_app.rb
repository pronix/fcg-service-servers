module FCG::Service
  class UserApp < FCG::Service::Base
    include FCG::Rest
    restful
    
    # get a user by email
    get "/users/find_by_:field/:value" do
      user = User.first(:conditions => { params[:field].to_sym => params[:value] })
      if user and !user.destroyed?
        respond_with user
      else
        error 404, respond_with("user not found")
      end
    end

    # verify a user name and password
    post "/users/:id/sessions" do
      begin
        attributes = MessagePack.unpack(request.body.read)
        user = User.find(params[:id])
        if user and !user.destroyed? and user.authenticated?(attributes["password"])
          respond_with user
        else
          error 400, respond_with("invalid login credentials")
        end
      rescue => e
        error 400, respond_with(e.message)
      end
    end
  end
end