require File.dirname(__FILE__) + '/spec_helper'

describe "Party App" do
  before(:each) do
    Party.delete_all
  end

  describe "GET on /api/#{API_VERSION}/parties/:id" do
    before(:each) do
      user = Fabricate(:user)
      venue = Fabricate(:venue, :user_id => user.id.to_s)
      @party = Fabricate(:party, :venue => venue, :user_id => user.id.to_s)
      puts @party.errors.inspect
      @id = @party.id.to_s
    end
    
    it "should return an party by id: #{@id}" do
      get "/api/#{API_VERSION}/parties/#{@id}"
      puts last_response.body
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["_id"].should == @id
      attributes["address"].should == "279 Fifth Aparty"
      attributes["city"].should == "Brooklyn"
      attributes["state"].should == "NY"
      attributes["zipcode"].should == "11215"
      attributes["country"].should == "US"
      attributes["citycode"].should_not == "nyc"
    end
    
    it "should return a 404 for a party that doesn't exist" do
      get "/api/#{API_VERSION}/parties/foo"
      last_response.status.should == 404
    end
  end 
  
  describe "POST on /api/#{API_VERSION}/parties" do
    it "should create a party" do
      pending do
        party = {
          :name     => "Nightingale's",
          :address  => Faker::Address.street_address,
          :country  => "US",
          :zipcode  => Faker::Address.zip_code,
          :user_id  => "4c43475fff808d982a00001a"
        }
        post "/api/#{API_VERSION}/parties", party.to_json

        last_response.should be_ok
        attributes = JSON.parse(last_response.body)
        get "/api/#{API_VERSION}/parties/#{attributes['_id']}"
        attributes = JSON.parse(last_response.body)
        attributes["name"].should == "Nightingale's"
        attributes["user_id"].should == "4c43475fff808d982a00001a"        
      end
    end
  end

  describe "PUT on /api/#{API_VERSION}/parties/:id" do
    before(:each) do
      @party = Fabricate(:lounge)
      @id = @party.id.to_s
    end
    
    it "should update a party" do
      pending do
        new_zipcode = Faker::Address.zip_code
        put "/api/#{API_VERSION}/parties/#{@id}", { :zip_code => new_zipcode }.to_json
        last_response.should be_ok
        attributes = JSON.parse(last_response.body)
        get "/api/#{API_VERSION}/parties/#{@id}"
        attributes = JSON.parse(last_response.body)
        attributes["zip_code"].should == new_zipcode
      end
    end
  end
  
  describe "DELETE on /api/#{API_VERSION}/parties/:id" do
    before(:each) do
      @party = Fabricate(:bar)
      @id = @party.id.to_s
    end
    
    it "should delete a party" do
      pending do
        delete "/api/#{API_VERSION}/parties/#{@id}"
        last_response.should be_ok
        get "/api/#{API_VERSION}/parties/#{@id}"
        last_response.status.should == 404
      end
    end
  end
end