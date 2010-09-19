ENV["SINATRA_ENV"] = "test"
require ::File.dirname(__FILE__) + "/../config/boot.rb"
require File.dirname(__FILE__) + "/../fcg_activity_service"
require "spec/interop/test"

set :environment, :test
Test::Unit::TestCase.send :include, Rack::Test::Methods

def app
  FCG::ActivityService
end

describe "activity_app" do
  before(:each) do
    Activity.delete_all
  end

  describe "GET on /api/#{API_VERSION}/activities/:id" do
    before(:each) do
      act = Activity.create(
        :actor => {
          :display_name => "Paul Dix",
          :url => "http://www.fcgid.com/person/paulDiddy", 
          :photo => nil
        },
        :object => {
          
        },
        :verb => FCG::ACTIVITY::VERBS::VIEW,
        :title => "Paul Dix viewed a photo in Rip's Photo Album",
        :site => "ATP",
        :visible => false
      )
      
      @id = act.id.to_s
    end
    
    it "should return a activity by id: #{@id}" do
      get "/api/#{API_VERSION}/activities/#{@id}"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["actor"]["display_name"].should == "Paul Dix"
    end

    it "should return a activity with an verb" do
      get "/api/#{API_VERSION}/activities/#{@id}"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["verb"].should == FCG::ACTIVITY::VERBS::VIEW.to_s
    end

    it "should return site" do
      get "/api/#{API_VERSION}/activities/#{@id}"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["site"].should == "ATP"
    end

    it "should return a 404 for a activity that doesn't exist" do
      get "/api/#{API_VERSION}/activities/foo"
      last_response.status.should == 404
    end
  end
  
  describe "POST on /api/#{API_VERSION}/activities" do
    it "should create a activity" do
      post "/api/#{API_VERSION}/activities", {
          :actor => {
            :display_name => "Trotter Cashion",
            :url => "http://www.fcgid.com/person/tcash"
          },
          :object => {},
          :verb => FCG::ACTIVITY::VERBS::MARK_AS_FAVORITE,
          :title => "Paul Dix marked as favorite a photo in Rip's Photo Album",
          :site => "ATP"}.to_json
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      get "/api/#{API_VERSION}/activities/#{attributes['id']}"
      attributes = JSON.parse(last_response.body)
      attributes["actor"]["display_name"].should == "Trotter Cashion"
      attributes["actor"]["url"].should == "http://www.fcgid.com/person/tcash"
    end
  end

  describe "DELETE on /api/#{API_VERSION}/activities/:id" do
    before(:each) do
      u = Activity.create(
        :actor => {
          :display_name => "Paul Dix",
          :url => "http://www.fcgid.com/person/paulDiddy"
        },
        :object => {},
        :verb => FCG::ACTIVITY::VERBS::MARK_AS_FAVORITE,
        :title => "Paul Dix marked as favorite a photo in Rip's Photo Album",
        :site => "ATP",
        :visible => false
      )
      @id = u.id.to_s
    end
    it "should delete a activity" do
      delete "/api/#{API_VERSION}/activities/#{@id}"
      last_response.should be_ok
      get "/api/#{API_VERSION}/activities/#{@id}"
      last_response.status.should == 404
    end
  end
end
