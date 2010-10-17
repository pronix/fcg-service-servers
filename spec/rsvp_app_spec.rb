require File.dirname(__FILE__) + '/spec_helper'

describe "Rsvp App" do
  before(:each) do
    Rsvp.delete_all
  end
  
  describe "GET on /rsvps/:id" do
    before(:each) do
      @rsvp = Fabricate(:rsvp)
      @id = @rsvp.id.to_s
    end
    
    it "should return an rsvp by id: #{@id}" do
      get "/rsvps/#{@id}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["id"].should == @id
      attributes["name"].should == "Hailey Salley"
      attributes["number_of_guests"].should == 4
    end
    
    it "should return a 404 for a rsvp that doesn't exist" do
      get "/rsvps/foo"
      last_response.status.should == 404
      last_response.body.should == "rsvp not found".to_msgpack
    end
  end
  
  describe "POST on /rsvps" do
    it "should create a rsvp" do
      rsvp = {
        :name              => "John Starks",
        :number_of_guests  => 12,
        :message           => Faker::Lorem.sentences(12).join(". ")
      }
      post "/rsvps", rsvp.to_msgpack

      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      get "/rsvps/#{attributes["id"]}"
      attributes = MessagePack.unpack(last_response.body)
      attributes["name"].should == "John Starks"
      attributes["number_of_guests"].should == 12
      attributes["message"].should == rsvp[:message]
    end
  end

  describe "PUT on /rsvps/:id" do
    before(:each) do
      @rsvp = Fabricate(:rsvp2)
      @id = @rsvp.id.to_s
    end
    
    it "should update a rsvp" do
      rsvp = {
        :number_of_guests => 5
      }
      put "/rsvps/#{@id}", rsvp.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["number_of_guests"].should == 5
    end
  end
  
  describe "DELETE on /rsvps/:id" do
    before(:each) do
      @rsvp = Fabricate(:rsvp)
      @id = @rsvp.id.to_s
    end
    
    it "should delete a rsvp" do
      delete "/rsvps/#{@id}"
      last_response.should be_ok
      get "/rsvps/#{@id}"
      last_response.status.should == 404
    end
  end
end