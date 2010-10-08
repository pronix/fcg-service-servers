require File.dirname(__FILE__) + '/spec_helper'

describe "Rsvp App" do
  before(:each) do
    Rsvp.delete_all
  end
  
  describe "GET on /api/#{API_VERSION}/rsvps/:id" do
    before(:each) do
      @rsvp = Fabricate(:rsvp)
      @id = @rsvp.id.to_s
    end
    
    it "should return an rsvp by id: #{@id}" do
      get "/api/#{API_VERSION}/rsvps/#{@id}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["id"].should == @id
      attributes["name"].should == "Hailey Salley"
      attributes["number_of_guests"].should == 4
    end
    
    it "should return a 404 for a rsvp that doesn't exist" do
      get "/api/#{API_VERSION}/rsvps/foo"
      last_response.status.should == 404
      last_response.body.should == "rsvp not found".to_msgpack
    end
  end
  
  describe "POST on /api/#{API_VERSION}/rsvps" do
    it "should create a rsvp" do
      rsvp = {
        :name              => "John Starks",
        :number_of_guests  => 12,
        :message           => Faker::Lorem.sentences(12).join(". ")
      }
      post "/api/#{API_VERSION}/rsvps", rsvp.to_msgpack

      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      get "/api/#{API_VERSION}/rsvps/#{attributes["id"]}"
      attributes = MessagePack.unpack(last_response.body)
      attributes["name"].should == "John Starks"
      attributes["number_of_guests"].should == 12
      attributes["message"].should == rsvp[:message]
    end
  end

  describe "PUT on /api/#{API_VERSION}/rsvps/:id" do
    before(:each) do
      @rsvp = Fabricate(:rsvp2)
      @id = @rsvp.id.to_s
    end
    
    it "should update a rsvp" do
      rsvp = {
        :number_of_guests => 5
      }
      put "/api/#{API_VERSION}/rsvps/#{@id}", rsvp.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["number_of_guests"].should == 5
    end
  end
  
  describe "DELETE on /api/#{API_VERSION}/rsvps/:id" do
    before(:each) do
      @rsvp = Fabricate(:rsvp)
      @id = @rsvp.id.to_s
    end
    
    it "should delete a rsvp" do
      delete "/api/#{API_VERSION}/rsvps/#{@id}"
      last_response.should be_ok
      get "/api/#{API_VERSION}/rsvps/#{@id}"
      last_response.status.should == 404
    end
  end
end