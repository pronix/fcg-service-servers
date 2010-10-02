require File.dirname(__FILE__) + '/spec_helper'

def venue_hash
  {
    :name => "Aperitivo",
    :address => "279 Fifth Avenue",
    :city => "Brooklyn",
    :state => "NY",
    :country => "US", 
    :zipcode => "11215",
    :lat => nil,
    :lng => nil,
    :id => "4d43475fff808d982a00001a",
    :user_id => "4c43475fff808d982a00001a"
  }
end

def party_hash  
  {
    :title => "Get down on it Tuesdays",
    :music => "Hip-Hop",
    :description => "Elementum. Montes nascetur aenean porta platea et scelerisque augue porta, egestas tristique ultricies ac, mid sociis sed nascetur. Ut vut! Ultrices? Cum quis natoque? Parturient adipiscing integer ridiculus, montes nunc. Ultricies dolor urna nec sociis.", 
    :start_time => "10:00pm",
    :end_time => "4:00am",
  }
end

def event_hash
  {
    :date => Date.new.slashed,
    :start_time => "10:00pm",
    :end_time => "4:00am",
    :user_id => "4c43475fff808d982a00001a", 
    :party_id => "4f43475fff808d982a00001a", 
    :venue => venue_hash,
    :party => party_hash
  }
end

def create_valid_event
  # validates_presence_of :user_id, :party_id, :venue_id
  # validates_format_of :start_time, :with => /^(0?[1-9]|1[0-2]):(00|15|30|45)(a|p)m$/i
  # validates_format_of :end_time, :with => /^(0?[1-9]|1[0-2]):(00|15|30|45)(a|p)m$/i
  Event.create(event_hash)
end

describe "Event App" do
  before(:each) do
    Event.delete_all
  end

  describe "GET on /api/#{API_VERSION}/events/:id" do
    before(:each) do
      create_valid_event
      @id = Event.first.id.to_s if Event.first.respond_to? :id
    end
    
    it "should return an event by id: #{@id}" do
      get "/api/#{API_VERSION}/events/#{@id}"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      puts attributes["venue"].inspect
      attributes["_id"].should == @id
      attributes["party_id"].should == "4f43475fff808d982a00001a"
      attributes["venue"]["id"].should == "4d43475fff808d982a00001a"
      attributes["user_id"].should == "4c43475fff808d982a00001a"
    end
    
    it "should return a 404 for a event that doesn't exist" do
      get "/api/#{API_VERSION}/events/foo"
      last_response.status.should == 404
    end
  end
  
  describe "POST on /api/#{API_VERSION}/events" do
    it "should create a event" do
      post "/api/#{API_VERSION}/events", event_hash.to_json
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      get "/api/#{API_VERSION}/events/#{attributes['_id']}"
      attributes = JSON.parse(last_response.body)
      attributes["party"]["title"].should == "Get down on it Tuesdays"
      attributes["user_id"].should == "4c43475fff808d982a00001a"
    end
  end

  describe "DELETE on /api/#{API_VERSION}/events/:id" do
    before(:each) do
      create_valid_event
      @id = Event.first.id.to_s if Event.first.respond_to? :id
    end
    it "should delete a event" do
      delete "/api/#{API_VERSION}/events/#{@id}"
      last_response.should be_ok
      get "/api/#{API_VERSION}/events/#{@id}"
      last_response.status.should == 404
    end
  end
end
