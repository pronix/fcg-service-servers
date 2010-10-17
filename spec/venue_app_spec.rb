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