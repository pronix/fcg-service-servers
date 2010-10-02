require File.dirname(__FILE__) + '/spec_helper'

describe "Event App" do
  before(:each) do
    Event.delete_all
  end

  describe "GET on /api/#{API_VERSION}/events/:id" do
    before(:each) do
      @event = Fabricate(:tomorrow_event)
      @id = @event.id.to_s
    end
    
    it "should return an event by id: #{@id}" do
      get "/api/#{API_VERSION}/events/#{@id}"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["_id"].should == @id
      attributes["party_id"].should == "4f43475fff808d982a00001a"
      attributes["venue"]["_id"].should == "4cf3475fff808d982a00001a"
      attributes["user_id"].should == "4c43475fff808d982a00001a"
    end
    
    it "should return a 404 for a event that doesn't exist" do
      get "/api/#{API_VERSION}/events/foo"
      last_response.status.should == 404
    end
  end
  
  describe "POST on /api/#{API_VERSION}/events" do
    it "should create a event" do
      venue = {
        :name     => "Nightingale's",
        :address  => Faker::Address.street_address,
        :country  => "US",
        :zipcode  => Faker::Address.zip_code,
        :user_id  => "4c43475fff808d982a00001a"
      }
      
      event = {
        :date        => Date.new.slashed,
        :start_time  => "10:00pm",
        :end_time    => "4:00am",
        :user_id     => "4c43475fff808d982a00001a",
        :party_id    => "4f43475fff808d982a00001a",
        :venue       => venue
      }
      
      post "/api/#{API_VERSION}/events", event.to_json
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      get "/api/#{API_VERSION}/events/#{attributes['_id']}"
      attributes = JSON.parse(last_response.body)
      attributes["venue"]["name"].should == "Nightingale's"
      attributes["user_id"].should == "4c43475fff808d982a00001a"
    end
  end

  describe "DELETE on /api/#{API_VERSION}/events/:id" do
    before(:each) do
      @event = Fabricate(:tomorrow_event)
      @id = @event.id.to_s
    end
    
    it "should delete a event" do
      delete "/api/#{API_VERSION}/events/#{@id}"
      last_response.should be_ok
      get "/api/#{API_VERSION}/events/#{@id}"
      last_response.status.should == 404
    end
  end
end
