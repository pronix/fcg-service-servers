require File.dirname(__FILE__) + '/spec_helper'

describe "Party App" do
  before(:each) do
    Party.delete_all
    User.delete_all
    Venue.delete_all
  end

  describe "GET on /api/#{API_VERSION}/parties/:id" do
    before(:each) do
      @user   = Fabricate(:user)
      @venue  = Fabricate(:venue, :user_id => @user.id.to_s)
      @party  = Fabricate(:party, :venue => @venue.to_hash, :user_id => @user.id.to_s)
      @id     = @party.id.to_s
    end
    
    it "should return an party by id: #{@id}" do
      get "/api/#{API_VERSION}/parties/#{@id}"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["_id"].should == @id
      date = (Date.today + 7).slashed
      attributes["next_date"] == date
      attributes["start_time"] == "10:00pm"
      attributes["end_time"] == "4:00am"
      attributes["events"].should include(Date.parse(date).to_s)
      attributes["venue"].keys.sort.should == @venue.to_hash.keys.sort
      attributes["venue"].each_pair do |key, value|
        value.should == @venue.to_hash[key] unless ["created_at", "updated_at"].include?(key)
      end
    end
    
    it "should return a 404 for a party that doesn't exist" do
      get "/api/#{API_VERSION}/parties/foo"
      last_response.status.should == 404
    end
  end 
  
  describe "POST on /api/#{API_VERSION}/parties" do
    before(:each) do
      @venue  = Fabricate(:venue)
      @user   = Fabricate(:user)
    end
    
    it "should create a party" do
      date = (Date.today + 14).slashed
      party = {
        :title        => "Prada Launch Party",
        :next_date    => date,
        :start_time   => "10:00pm",
        :end_time     => "2:00am",
        :music        => "R&B",
        :description  => Faker::Lorem.paragraphs(1),
        :user_id      => @user.id.to_s,
        :venue_id     => @venue.id.to_s
      }
      
      post "/api/#{API_VERSION}/parties", party.to_json
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      get "/api/#{API_VERSION}/parties/#{attributes['_id']}"
      attributes = JSON.parse(last_response.body)
      attributes["title"].should == party[:title]
      attributes["user_id"].should == @user.id.to_s
      attributes["venue"]["id"].should == @venue.id.to_s
      attributes["venue"]["citycode"].should == "nyc"
      attributes["length_in_hours"].should == 4.0
       
    end
  end

  describe "PUT on /api/#{API_VERSION}/parties/:id" do
    before(:each) do
      @user   = Fabricate(:bryan)
      @venue  = Fabricate(:lounge, :user_id => @user.id)
      @venue2 = Fabricate(:venue, :user_id => @user.id)
      @party  = Fabricate(:party, :venue => @venue.to_hash, :user_id => @user.id)
      @id     = @party.id.to_s
    end
    
    it "should update a party" do
      new_title = "#{Faker::Company.name} Launch Party"
      put "/api/#{API_VERSION}/parties/#{@id}", { :title => new_title }.to_json
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      get "/api/#{API_VERSION}/parties/#{@id}"
      attributes = JSON.parse(last_response.body)
      attributes["title"].should == new_title
    end
    
    it "should change the party venue" do
      put "/api/#{API_VERSION}/parties/#{@id}", { :venue => @venue2.to_hash }.to_json
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      get "/api/#{API_VERSION}/parties/#{@id}"
      attributes = JSON.parse(last_response.body)
      attributes["venue"].each_pair do |key, value|
        value.should == @venue2.to_hash[key] unless ["created_at", "updated_at"].include?(key)
      end
      attributes["venue"]["time_zone"].should_not == @party.venue["time_zone"]
    end
  end
  
  describe "DELETE on /api/#{API_VERSION}/parties/:id" do
    before(:each) do
      @user = Fabricate(:bryan)
      @venue = Fabricate(:venue, :user_id => @user.id)
      @party = Fabricate(:party, :venue => @venue.to_hash, :user_id => @user.id)
      @id = @party.id.to_s
    end
    
    it "should delete a party" do
      delete "/api/#{API_VERSION}/parties/#{@id}"
      last_response.should be_ok
      get "/api/#{API_VERSION}/parties/#{@id}"
      last_response.status.should == 404
    end
  end
end