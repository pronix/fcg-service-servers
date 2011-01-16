require File.dirname(__FILE__) + '/spec_helper'

describe "Event App" do
  before(:each) do
    Event.delete_all
  end

  describe "GET on /events/:id" do
    before(:each) do
      @event = Fabricate(:tomorrow_event)
      @id = @event.id.to_s
    end
    
    it "should return an event by id: #{@id}" do
      get "/events/#{@id}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["id"].should == @id
      attributes["party_id"].should == "4f43475fff808d982a00001a"
      attributes["venue"]["_id"].should == "4cf3475fff808d982a00001a"
      attributes["user_id"].should == "4c43475fff808d982a00001a"
    end
    
    it "should return a 404 for a event that doesn't exist" do
      get "/events/foo"
      last_response.status.should == 404
    end
  end

  describe "GET on /events/citycode/:citycode" do
    before(:each) do
      @event = Fabricate(:tomorrow_event)
      @id = @event.id.to_s
    end

    it "should return an array of matched event" do
      get "/events/citycode/#{@event.venue[:citycode]}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes.class.should == Array
      attributes[0]["venue"]["citycode"].should == @event.venue["citycode"]
    end

    it "should return an empty array for a citycode that doesn't have any events" do
      get "/events/citycode/hou"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes.class.should == Array
      attributes.length.should == 0
    end
  end
  
  describe "POST on /events" do
    it "should create a event" do
      venue = {
        :name     => "Nightingale's",
        :address  => Faker::Address.street_address,
        :country  => "US",
        :zipcode  => Faker::Address.zip_code,
        :user_id  => "4c43475fff808d982a00001a"
      }
      
      event = {
        :date        => Date.today.slashed,
        :start_time  => "10:00pm",
        :end_time    => "4:00am",
        :user_id     => "4c43475fff808d982a00001a",
        :party_id    => "4f43475fff808d982a00001a",
        :venue       => venue
      }
      
      post "/events", event.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      get "/events/#{attributes["id"]}"
      attributes = MessagePack.unpack(last_response.body)
      attributes["venue"]["name"].should == "Nightingale's"
      attributes["user_id"].should == "4c43475fff808d982a00001a"
    end
  end

  describe "DELETE on /events/:id" do
    before(:each) do
      @event = Fabricate(:tomorrow_event)
      @id = @event.id.to_s
    end
    
    it "should delete a event" do
      delete "/events/#{@id}"
      last_response.should be_ok
      get "/events/#{@id}"
      last_response.status.should == 404
    end
  end
end
