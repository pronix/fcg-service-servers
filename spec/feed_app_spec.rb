require File.dirname(__FILE__) + '/spec_helper'

describe "Feed App" do
  before(:each) do
    Feed.delete_all
  end
  
  describe "GET on /api/#{API_VERSION}/feeds/:id" do
    before(:each) do
      @feed = Fabricate(:feed)
      @id = @feed.id.to_s
    end
    
    it "should return an feed by id: #{@id}" do
      get "/api/#{API_VERSION}/feeds/#{@id}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["id"].should == @id
      attributes["title"].should == "Let'em Shine"
      attributes["user_id"].should == "4c43475fff808d982a00001a"
      attributes["site"].should == "alltheparties.com"
      attributes["record"].should == "user:4c43475fff808d982a00001a"
    end
    
    it "should return a 404 for a feed that doesn't exist" do
      get "/api/#{API_VERSION}/feeds/foo"
      last_response.status.should == 404
      last_response.body.should == "feed not found".to_msgpack
    end
  end
  
  describe "POST on /api/#{API_VERSION}/feeds" do
    it "should create a feed" do
      feed = {
        :title        =>  "Let'em Shine",
        :user_id      =>  "4c43475fff808d982a00001a",
        :site         =>  "alltheparties.com",
        :record =>  "user:4c43475fff808d982a00001a"
      }
      post "/api/#{API_VERSION}/feeds", feed.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      get "/api/#{API_VERSION}/feeds/#{attributes["id"]}"
      attributes = MessagePack.unpack(last_response.body)
    end
  end

  describe "PUT on /api/#{API_VERSION}/feeds/:id" do
    before(:each) do
      @feed = Fabricate(:feed)
      @id = @feed.id.to_s
    end
    
    it "should update a feed" do
      feed = {
        :record =>  "user:4ffff75fff808d982a00001a"
      }
      put "/api/#{API_VERSION}/feeds/#{@id}", feed.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["record"].should == feed[:record]
    end
  end
  
  describe "DELETE on /api/#{API_VERSION}/feeds/:id" do
    before(:each) do
      @feed = Fabricate(:feed)
      @id = @feed.id.to_s
    end
    
    it "should delete a feed" do
      delete "/api/#{API_VERSION}/feeds/#{@id}"
      last_response.should be_ok
      get "/api/#{API_VERSION}/feeds/#{@id}"
      last_response.status.should == 404
    end
  end
end