require File.dirname(__FILE__) + '/spec_helper'

describe "Venue App" do
  before(:each) do
    Venue.delete_all
  end

  describe "GET on /api/#{API_VERSION}/venues/:id" do
    before(:each) do
      @venue = Fabricate(:bar)
      @id = @venue.id.to_s
    end
    
    it "should return an venue by id: #{@id}" do
      get "/api/#{API_VERSION}/venues/#{@id}"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["_id"].should == @id
      attributes["address"].should == "279 Fifth Avenue"
      attributes["city"].should == "Brooklyn"
      attributes["state"].should == "NY"
      attributes["zipcode"].should == "11215"
      attributes["country"].should == "US"
      attributes["citycode"].should_not == "nyc"
    end
    
    it "should return a 404 for a venue that doesn't exist" do
      get "/api/#{API_VERSION}/venues/foo"
      last_response.status.should == 404
    end
  end
  
  describe "POST on /api/#{API_VERSION}/venues" do
    it "should create a venue" do
      venue = {
        :name     => "Nightingale's",
        :address  => Faker::Address.street_address,
        :country  => "US",
        :zipcode  => Faker::Address.zip_code,
        :user_id  => "4c43475fff808d982a00001a"
      }
      post "/api/#{API_VERSION}/venues", venue.to_json
      
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      get "/api/#{API_VERSION}/venues/#{attributes['_id']}"
      attributes = JSON.parse(last_response.body)
      attributes["name"].should == "Nightingale's"
      attributes["user_id"].should == "4c43475fff808d982a00001a"
    end
  end

  describe "PUT on /api/#{API_VERSION}/venues/:id" do
    before(:each) do
      @venue = Fabricate(:lounge)
      @id = @venue.id.to_s
    end
    
    it "should update a venue" do
      new_zipcode = Faker::Address.zip_code
      put "/api/#{API_VERSION}/venues/#{@id}", { :zip_code => new_zipcode }.to_json
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      get "/api/#{API_VERSION}/venues/#{@id}"
      attributes = JSON.parse(last_response.body)
      attributes["zip_code"].should == new_zipcode
    end
  end
  
  describe "DELETE on /api/#{API_VERSION}/venues/:id" do
    before(:each) do
      @venue = Fabricate(:bar)
      @id = @venue.id.to_s
    end
    
    it "should delete a venue" do
      delete "/api/#{API_VERSION}/venues/#{@id}"
      last_response.should be_ok
      get "/api/#{API_VERSION}/venues/#{@id}"
      last_response.status.should == 404
    end
  end
end