require File.dirname(__FILE__) + '/test_helper'

def app
  FCG::Service::VenueApp
end

describe "venue_app" do
  before(:each) do
    Venue.delete_all
    # init Redis.new(OPTIONS)
    # [:id, :active, :address, :city, :citycode, :country, :created_at, :deleted_at, :lat, :lng, :name, :state, :time_zone, :updated_at, :user_id, :zipcode]
  end

  describe "GET on /api/#{API_VERSION}/venues/:id" do
    before(:each) do
      Venue.create(
        :name => "Aperitivo",
        :address => "279 Fifth Avenue",
        # :city => "Brooklyn",
        # :state => "NY",
        :country => "US", 
        :zipcode => "11215",
        :user_id => "4c43475fff808d982a00001a"
      )
      @id = Venue.first.id.to_s if Venue.first.respond_to? :id
    end
    
    it "should return an venue by id: #{@id}" do
      get "/api/#{API_VERSION}/venues/#{@id}"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["id"].should == @id
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
      post "/api/#{API_VERSION}/venues", {
        :name => "Nightingale's",
        :address => "279 Fifth Avenue",
        :city => "Brooklyn",
        :state => "NY",
        :zipcode => "11215",
        :country => "US",
        :user_id => "4c43475fff808d982a00001a"
      }.to_json
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      get "/api/#{API_VERSION}/venues/#{attributes['id']}"
      attributes = JSON.parse(last_response.body)
      attributes["name"].should == "Nightingale's"
      attributes["user_id"].should == "4c43475fff808d982a00001a"
    end
  end

  describe "DELETE on /api/#{API_VERSION}/venues/:id" do
    before(:each) do
      obj = Venue.create(
        :name => "Nightingale's",
        :address => "279 Fifth Avenue",
        :city => "Brooklyn",
        :state => "NY",
        :zipcode => "11215",
        :country => "US",
        :user_id => "4c43475fff808d982a00001a"
      )
      @id = obj.id.to_s
    end
    it "should delete a venue" do
      delete "/api/#{API_VERSION}/venues/#{@id}"
      last_response.should be_ok
      get "/api/#{API_VERSION}/venues/#{@id}"
      last_response.status.should == 404
    end
  end
end
