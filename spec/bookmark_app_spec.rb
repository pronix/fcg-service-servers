require File.dirname(__FILE__) + '/spec_helper'

describe "Bookmark App" do
  before(:each) do
    Bookmark.delete_all
  end
  
  describe "GET on /bookmarks/:id" do
    before(:each) do
      @bookmark = Fabricate(:bookmark)
      @id = @bookmark.id.to_s
    end
    
    it "should return an bookmark by id: #{@id}" do
      get "/bookmarks/#{@id}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["id"].should == @id
    end
    
    it "should return a 404 for a bookmark that doesn't exist" do
      get "/bookmarks/foo"
      last_response.status.should == 404
      last_response.body.should == "bookmark not found".to_msgpack
    end
  end
  
  describe "POST on /bookmarks" do
    it "should create a bookmark" do
      bookmark = {
        :user_id         => "4c5f475fff808d982a00001a",
        :title           => "/profile/jeremiah",
        :path            => "/profile/jeremiah",
        :bookmark_type   => "misc"
      }
      post "/bookmarks", bookmark.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      get "/bookmarks/#{attributes["id"]}"
      attributes = MessagePack.unpack(last_response.body)
    end

    it "should update a bookmark, not save one path twice" do
      bookmark = {
        :user_id         => "4c5f475fff808d982a00001a",
        :title           => "/profile/jeremiah",
        :path            => "/profile/jeremiah",
        :bookmark_type   => "misc"
      }
      post "/bookmarks", bookmark.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      id1 = attributes["id"]
      attributes["title"].should == bookmark[:title]

      bookmark[:title] = "new title"
      post "/bookmarks", bookmark.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      id2 = attributes["id"]
      id2.should == id1
      attributes["title"].should == bookmark[:title]
    end
  end

  describe "PUT on /bookmarks/:id" do
    before(:each) do
      @bookmark = Fabricate(:bookmark)
      @id = @bookmark.id.to_s
    end
    
    it "should update a bookmark" do
      bookmark = {
        :path => "/profile/jeremiah6473865255267383"
      }
      put "/bookmarks/#{@id}", bookmark.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["path"].should == bookmark[:path]
    end
  end
  
  describe "DELETE on /bookmarks/:id" do
    before(:each) do
      @bookmark = Fabricate(:bookmark)
      @id = @bookmark.id.to_s
    end
    
    it "should delete a bookmark" do
      delete "/bookmarks/#{@id}"
      last_response.should be_ok
      get "/bookmarks/#{@id}"
      last_response.status.should == 404
    end
  end
end