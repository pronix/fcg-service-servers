require File.dirname(__FILE__) + '/spec_helper'

describe "Venue App" do
  before(:each) do
    Venue.delete_all
  end

  describe "GET on /venues/:id" do
    before(:each) do
      @venue = Fabricate(:bar)
      @id = @venue.id.to_s
    end
    
    it "should return an venue by id: #{@id}" do
      get "/venues/#{@id}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["id"].should == @id
      attributes["address"].should == "279 Fifth Avenue"
      attributes["city"].should == "Brooklyn"
      attributes["state"].should == "NY"
      attributes["zipcode"].should == "11215"
      attributes["country"].should == "US"
      attributes["citycode"].should_not == "nyc"
    end
    
    it "should return a 404 for a venue that doesn't exist" do
      get "/venues/foo"
      last_response.status.should == 404
    end
  end

  describe "GET on /venues/autocomplete" do
    before(:each) do
      @venue = Fabricate(:bar)
      @id = @venue.id.to_s
    end

    it "should return an array of matched venue" do
      get "/venues/autocomplete", :term => @venue.name[0,2]
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes.class.should == Array
      attributes[0]["name"].should == @venue.name
    end

    it "should return an empty array" do
      get "/venues/autocomplete", :term => "abc"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes.class.should == Array
      attributes.length.should == 0
    end
  end
  
  describe "POST on /venues" do
    it "should create a venue" do
      venue = {
        :name     => "Nightingale's",
        :address  => Faker::Address.street_address,
        :country  => "US",
        :citycode => "nyc",
        :zipcode  => Faker::Address.zip_code,
        :user_id  => "4c43475fff808d982a00001a"
      }
      post "/venues", venue.to_msgpack
      
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      get "/venues/#{attributes["id"]}"
      attributes = MessagePack.unpack(last_response.body)
      attributes["name"].should == "Nightingale's"
      attributes["user_id"].should == "4c43475fff808d982a00001a"
      attributes["citycode"].should == "nyc"
    end

    it "should not duplicate venue - a similar venue name that have the same address" do
      venue = {
        :name     => "Nightingale",
        :address  => "140 Market st",
        :country  => "US",
        :city     => "San Francisco",
        :state    => "CA",
        :zipcode  => 94105,
        :user_id  => "4c43475fff808d982a00001a"
      }
      post "/venues", venue.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      saved_venue_id = attributes["id"]
      get "/venues/#{saved_venue_id}"
      attributes = MessagePack.unpack(last_response.body)
      attributes["name"].should == "Nightingale"

      venue = {
        :name     => "Nightingale 1",
        :address  => "140 Market st",
        :country  => "US",
        :city     => "San Francisco",
        :state    => "CA",
        :zipcode  => 94105,
        :user_id  => "4c43475fff808d982a00002b"
      }
      post "/venues", venue.to_msgpack
      attributes = MessagePack.unpack(last_response.body)
      attributes["id"].should == saved_venue_id
      attributes["name"].should == "Nightingale"
      attributes["user_id"].should == "4c43475fff808d982a00001a"
      Venue.where({:name => "Nightingale 1"}).length.should == 0
    end

    it "should create venue that have the same address, but not similar name" do
      venue = {
        :name     => "Nightingale",
        :address  => "140 Market st",
        :country  => "US",
        :city     => "San Francisco",
        :state    => "CA",
        :zipcode  => 94105,
        :user_id  => "4c43475fff808d982a00001a"
      }
      post "/venues", venue.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      saved_venue_id = attributes["id"]
      get "/venues/#{saved_venue_id}"
      attributes = MessagePack.unpack(last_response.body)
      attributes["name"].should == "Nightingale"

      venue = {
        :name     => "Another venue",
        :address  => "140 Market st",
        :country  => "US",
        :city     => "San Francisco",
        :state    => "CA",
        :zipcode  => 94105,
        :user_id  => "4c43475fff808d982a00002b"
      }
      post "/venues", venue.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["id"].should_not eql(saved_venue_id)
      get "/venues/#{attributes["id"]}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["name"].should == "Another venue"
    end

    it "should set lat, lng, city, state, timezone by address and zipcode" do
      venue = {
        :name     => "Nightingale 3",
        :address  => "140 Market st, San Francisco",
        :country  => "US",
        :zipcode  => 94105,
        :user_id  => "4c43475fff808d982a00001a"
      }
      post "/venues", venue.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["lat"].should_not be_nil
      attributes["lng"].should_not be_nil
      attributes["city"].should_not be_nil
      attributes["state"].should_not be_nil
      attributes["time_zone"].should_not be_nil
    end
  end

  describe "PUT on /venues/:id" do
    before(:each) do
      @venue = Fabricate(:lounge)
      @id = @venue.id.to_s
    end
    
    it "should update a venue" do
      new_zipcode = Faker::Address.zip_code
      put "/venues/#{@id}", { :zip_code => new_zipcode }.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["zip_code"].should == new_zipcode
    end
  end
  
  describe "DELETE on /venues/:id" do
    before(:each) do
      @venue = Fabricate(:bar)
      @id = @venue.id.to_s
    end
    
    it "should delete a venue" do
      delete "/venues/#{@id}"
      last_response.should be_ok
      get "/venues/#{@id}"
      last_response.status.should == 404
    end
  end
end