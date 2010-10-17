require File.dirname(__FILE__) + '/spec_helper'

describe "Status App" do
  before(:each) do
    Status.delete_all
  end
  
  describe "GET on /status/:id" do
    before(:each) do
      @status = Fabricate(:status)
      @id = @status.id.to_s
    end
    
    it "should return an status by id: #{@id}" do
      get "/status/#{@id}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["id"].should == @id
      attributes["user_id"].should == "4c43475fff808d982a00001a"
      attributes["message"].should == @status.message
      attributes["message_as_html"].should == "<p>The end is near at <a href=\"http://www.yahoo.com\">http://www.yahoo.com</a></p>\n"
    end
    
    it "should return a 404 for a status that doesn't exist" do
      get "/status/foo"
      last_response.status.should == 404
      last_response.body.should == "status not found".to_msgpack
    end
  end
  
  describe "POST on /status" do
    it "should create a status" do
      status = {
        :user_id => "4c43475fff808d982a00001a",
        :message => Faker::Lorem.words(12)
      }
      post "/status", status.to_msgpack

      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      get "/status/#{attributes["id"]}"
      attributes = MessagePack.unpack(last_response.body)
    end
  end
  
  describe "DELETE on /status/:id" do
    before(:each) do
      @status = Fabricate(:status)
      @id = @status.id.to_s
    end
    
    it "should delete a status" do
      delete "/status/#{@id}"
      last_response.should be_ok
      get "/status/#{@id}"
      last_response.status.should == 404
    end
  end
end