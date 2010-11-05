require File.dirname(__FILE__) + '/spec_helper'

describe "User App" do
  before(:each) do
    User.delete_all
  end

  describe "GET on /users/:id" do
    subject{ Fabricate(:pauld) }
    
    it "should return a user by id" do
      get "/users/#{subject.id}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["username"].should == "pauld"
    end

    it "should return a user with an email" do
      get "/users/#{subject.id}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["email"].should == subject.email
    end

    it "should not return a user's password" do
      get "/users/#{subject.id}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes.should_not have_key("password")
    end

    it "should return a 404 for a user that doesn't exist" do
      get "/users/foo"
      last_response.status.should == 404
    end
  end

  describe "GET on /users/find_by_:field/:email" do
    subject do
      Fabricate(:pauld){ username "PaulyD" }
    end

    it "should return a user by email" do
      get "/users/find_by_email/#{subject.email}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["username"].should == "paulyd"
    end
  end
  
  describe "POST on /users" do
    it "should create a user" do
      new_user = {
        :username => "trotter",
        :email    => "trotter@nospam.com",
        :password => "whatever"
      }
      post "/users", new_user.to_msgpack
          
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      get "/users/#{attributes["id"]}"
      attributes = MessagePack.unpack(last_response.body)
      attributes["username"].should  == "trotter"
      attributes["email"].should == "trotter@nospam.com"
    end
    
    it "should create a user" do
      new_user = {
        :username   => "joemocha",
        :email      => "onyekwelu@obukwelu.com",
        :password   => "test1test2",
        :last_name  => "Abdullah",
        :first_name => "Anik"
      }
      post "/users", new_user.to_msgpack
          
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      get "/users/#{attributes["id"]}"
      attributes = MessagePack.unpack(last_response.body)
      attributes["username"].should  == "joemocha"
      attributes["email"].should == "onyekwelu@obukwelu.com"
      attributes["last_name"].should == "Abdullah"
      attributes["first_name"].should == "Anik"
      attributes["location"].class.should == Hash
      attributes["location"]["country"].should == "US"
    end
  end

  describe "PUT on /users/:id" do
    before(:each) do
      @user = Fabricate(:bryan)
      @id = @user.id.to_s
    end
    
    it "should update a user's bio" do
      put "/users/#{@id}", { :bio => "testing freak"}.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["bio"].should == "testing freak"
    end
 
    it "should update a user's first and last name" do
      put "/users/#{@id}", { :last_name => "Denzel", :first_name => "Hampton"}.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["last_name"].should == "Denzel"
      attributes["first_name"].should == "Hampton"
    end
    
    it "should not add user with same username" do
      post "/users", {
        :username => "bryan",
        :email => "bigsmyG2@aol.com",
        :password => "whatever"
      }.to_msgpack
      last_response.should_not be_ok
      errors = MessagePack.unpack(last_response.body)
    end
    
    it "should not add user with same email address" do
      post "/users", {
        :username => "bryan2",
        :email => "bigsmyG@aol.com",
        :password => "whatever"
      }.to_msgpack
      last_response.should_not be_ok
      errors = MessagePack.unpack(last_response.body)
    end
  end

  describe "DELETE on /users/:id" do
    subject{ Fabricate(:bryan) }
    
    it "should delete a user" do
      delete "/users/#{subject.id}"
      last_response.should be_ok
      get "/users/#{subject.id}"
      last_response.status.should == 404
    end
  end

  describe "POST on /users/:id/sessions" do
    subject{ Fabricate(:bryan) }

    it "should return the user object on valid credentials" do
      post "/users/#{subject.id}/sessions", {
        :password => "whatever"}.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["username"].should == "bryan"
    end

    it "should fail on invalid credentials" do
      post "/users/#{subject.id}/sessions", {
        :password => "wrong"}.to_msgpack
      last_response.status.should == 400
    end
  end
end
