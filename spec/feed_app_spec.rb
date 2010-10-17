require File.dirname(__FILE__) + '/spec_helper'

describe "Feed App" do
  before(:each) do
    Feed.delete_all
  end
  
  describe "GET on /feeds/:id" do
    before(:each) do
      @feed = Fabricate(:feed)
      @id = @feed.id.to_s
    end
    
    it "should return an feed by id: #{@id}" do
      get "/feeds/#{@id}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["id"].should == @id
      attributes["title"].should == "Let'em Shine"
      attributes["user_id"].should == "4c43475fff808d982a00001a"
      attributes["site"].should == "alltheparties.com"
      attributes["record"].should == "user:4c43475fff808d982a00001a"
    end
    
    it "should return a 404 for a feed that doesn't exist" do
      get "/feeds/foo"
      last_response.status.should == 404
      last_response.body.should == "feed not found".to_msgpack
    end
  end
  
  describe "POST on /feeds" do
    it "should create a feed" do
      feed = {
        :title        =>  "Let'em Shine",
        :user_id      =>  "4c43475fff808d982a00001a",
        :site         =>  "alltheparties.com",
        :record =>  "user:4c43475fff808d982a00001a"
      }
      post "/feeds", feed.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      get "/feeds/#{attributes["id"]}"
      attributes = MessagePack.unpack(last_response.body)
    end
  end

  describe "PUT on /feeds/:id" do
    before(:each) do
      @feed = Fabricate(:feed)
      @id = @feed.id.to_s
    end
    
    it "should update a feed" do
      feed = {
        :record =>  "user:4ffff75fff808d982a00001a"
      }
      put "/feeds/#{@id}", feed.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["record"].should == feed[:record]
    end
  end
  
  describe "DELETE on /feeds/:id" do
    before(:each) do
      @feed = Fabricate(:feed)
      @id = @feed.id.to_s
    end
    
    it "should delete a feed" do
      delete "/feeds/#{@id}"
      last_response.should be_ok
      get "/feeds/#{@id}"
      last_response.status.should == 404
    end
  end
end