require File.dirname(__FILE__) + '/spec_helper'

describe "User App" do
  before(:each) do
    User.delete_all
  end

  describe "GET on /api/#{API_VERSION}/users/:id" do
    subject{ Fabricate(:pauld) }
    
    it "should return a user by id" do
      get "/api/#{API_VERSION}/users/#{subject.id}"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["username"].should == "pauld"
    end

    it "should return a user with an email" do
      get "/api/#{API_VERSION}/users/#{subject.id}"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["email"].should == subject.email
    end

    it "should not return a user's password" do
      get "/api/#{API_VERSION}/users/#{subject.id}"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes.should_not have_key("password")
    end

    it "should return a 404 for a user that doesn't exist" do
      get "/api/#{API_VERSION}/users/foo"
      last_response.status.should == 404
    end
  end

  describe "GET on /api/#{API_VERSION}/users/find_by_:field/:email" do
    subject do
      Fabricate(:pauld){ username "PaulyD" }
    end

    it "should return a user by email" do
      get "/api/#{API_VERSION}/users/find_by_email/#{subject.email}"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["username"].should == "paulyd"
    end
  end
  
  describe "POST on /api/#{API_VERSION}/users" do
    it "should create a user" do
      new_user = {
        :username => "trotter",
        :email    => "trotter@nospam.com",
        :password => "whatever"
      }
      post "/api/#{API_VERSION}/users", new_user.to_json
          
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      get "/api/#{API_VERSION}/users/#{attributes['_id']}"
      attributes = JSON.parse(last_response.body)
      attributes["username"].should  == "trotter"
      attributes["email"].should == "trotter@nospam.com"
    end
  end

  describe "PUT on /api/#{API_VERSION}/users/:id" do
    before(:each) do
      @user = Fabricate(:bryan)
      @id = @user.id.to_s
    end
    
    it "should update a user" do
      put "/api/#{API_VERSION}/users/#{@id}", { :bio => "testing freak"}.to_json
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["bio"].should == "testing freak"
    end
 
    it "should not add user with same username" do
      post "/api/#{API_VERSION}/users", {
        :username => "bryan",
        :email => "bigsmyG2@aol.com",
        :password => "whatever"
      }.to_json
      last_response.should_not be_ok
      errors = JSON.parse(last_response.body)
    end
    
    it "should not add user with same email address" do
      post "/api/#{API_VERSION}/users", {
        :username => "bryan2",
        :email => "bigsmyG@aol.com",
        :password => "whatever"
      }.to_json
      last_response.should_not be_ok
      errors = JSON.parse(last_response.body)
    end
  end

  describe "DELETE on /api/#{API_VERSION}/users/:id" do
    subject{ Fabricate(:bryan) }
    
    it "should delete a user" do
      delete "/api/#{API_VERSION}/users/#{subject.id}"
      last_response.should be_ok
      get "/api/#{API_VERSION}/users/#{subject.id}"
      last_response.status.should == 404
    end
  end

  describe "POST on /api/#{API_VERSION}/users/:id/sessions" do
    subject{ Fabricate(:bryan) }

    it "should return the user object on valid credentials" do
      post "/api/#{API_VERSION}/users/#{subject.id}/sessions", {
        :password => "whatever"}.to_json
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["username"].should == "bryan"
    end

    it "should fail on invalid credentials" do
      post "/api/#{API_VERSION}/users/#{subject.id}/sessions", {
        :password => "wrong"}.to_json
      last_response.status.should == 400
    end
  end
end
