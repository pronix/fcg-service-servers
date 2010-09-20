ENV["SINATRA_ENV"] = "test"
require File.dirname(__FILE__) + "/../lib/fcg-service-servers/apps"
require "rack/test"
require "spec/interop/test"

set :environment, :test
Test::Unit::TestCase.send :include, Rack::Test::Methods

def app
  FCG::Service::UserApp
end

describe "user_app" do
  before(:each) do
    User.delete_all
  end

  describe "GET on /api/#{API_VERSION}/users/:id" do
    before(:each) do
      u = User.create(
        :username => "paulD",
        :email => "paul@pauldix.net",
        :password => "strongpass"
      )
      @id = u.id.to_s
    end
    
    it "should return a user by id: #{@id}" do
      get "/api/#{API_VERSION}/users/#{@id}"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["username"].should == "pauld"
    end

    it "should return a user with an email" do
      get "/api/#{API_VERSION}/users/#{@id}"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["email"].should == "paul@pauldix.net"
    end

    it "should not return a user's password" do
      get "/api/#{API_VERSION}/users/#{@id}"
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
    before(:each) do
      User.create(
        :username => "paulyd",
        :email => "paul@pauldix.net",
        :password => "strongpass"
      )
    end

    it "should return a user by email" do
      get "/api/#{API_VERSION}/users/find_by_email/paul@pauldix.net"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["username"].should == "paulyd"
    end
  end
  
  describe "POST on /api/#{API_VERSION}/users" do
    it "should create a user" do
      post "/api/#{API_VERSION}/users", {
          :username => "trotter",
          :email    => "trotter@nospam.com",
          :password => "whatever"}.to_json
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      get "/api/#{API_VERSION}/users/#{attributes['id']}"
      attributes = JSON.parse(last_response.body)
      attributes["username"].should  == "trotter"
      attributes["email"].should == "trotter@nospam.com"
    end
  end

  describe "PUT on /api/#{API_VERSION}/users/:id" do
    before(:each) do
      u = User.create(
        :username => "bryan",
        :email => "bigsmyG@aol.com",
        :password => "whatever",
        :bio => "Always running 1500 meter dash!")
      @id = u.id.to_s
    end
    
    it "should update a user" do
      put "/api/#{API_VERSION}/users/#{@id}", { :bio => "testing freak"}.to_json
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      get "/api/#{API_VERSION}/users/#{@id}"
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
    before(:each) do
      u = User.create(
        :username     => "francis",
        :email    => "francis@igetsnospam.org",
        :password => "whatever")
      @id = u.id.to_s
    end
    it "should delete a user" do
      delete "/api/#{API_VERSION}/users/#{@id}"
      last_response.should be_ok
      get "/api/#{API_VERSION}/users/#{@id}"
      last_response.status.should == 404
    end
  end

  describe "POST on /api/#{API_VERSION}/users/:id/sessions" do
    before(:each) do
      u = User.create(:username => "josh", :password => "nyc.rb rules", :email => "josh@sessions.com")
      @id = u.id.to_s
    end

    it "should return the user object on valid credentials" do
      post "/api/#{API_VERSION}/users/#{@id}/sessions", {
        :password => "nyc.rb rules"}.to_json
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["username"].should == "josh"
    end

    it "should fail on invalid credentials" do
      post "/api/#{API_VERSION}/users/#{@id}/sessions", {
        :password => "wrong"}.to_json
      last_response.status.should == 400
    end
  end
end
