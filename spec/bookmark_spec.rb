require File.dirname(__FILE__) + '/spec_helper'

describe "Bookmark App" do
  before(:each) do
    Bookmark.delete_all
  end
  
  describe "GET on /api/#{API_VERSION}/bookmarks/:id" do
    before(:each) do
      @bookmark = Fabricate(:bookmark)
      @id = @bookmark.id.to_s
    end
    
    it "should return an bookmark by id: #{@id}" do
      get "/api/#{API_VERSION}/bookmarks/#{@id}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["id"].should == @id
    end
    
    it "should return a 404 for a bookmark that doesn't exist" do
      get "/api/#{API_VERSION}/bookmarks/foo"
      last_response.status.should == 404
      last_response.body.should == "bookmark not found"
    end
  end
  
  describe "POST on /api/#{API_VERSION}/bookmarks" do
    it "should create a bookmark" do
      pending do
        raise "create hash"
        bookmark = { }
        post "/api/#{API_VERSION}/bookmarks", bookmark.to_msgpack

        last_response.should be_ok
        attributes = MessagePack.unpack(last_response.body)
        get "/api/#{API_VERSION}/bookmarks/#{attributes["id"]}"
        attributes = MessagePack.unpack(last_response.body)
      end
    end
  end

  describe "PUT on /api/#{API_VERSION}/bookmarks/:id" do
    before(:each) do
      @bookmark = Fabricate(:bookmark)
      @id = @bookmark.id.to_s
    end
    
    it "should update a bookmark" do
      pending do
        raise "create hash"
        bookmark = { }
        put "/api/#{API_VERSION}/bookmarks/#{@id}", bookmark.to_msgpack
        last_response.should be_ok
        attributes = MessagePack.unpack(last_response.body)
      end
    end
  end
  
  describe "DELETE on /api/#{API_VERSION}/bookmarks/:id" do
    before(:each) do
      @bookmark = Fabricate(:bookmark)
      @id = @bookmark.id.to_s
    end
    
    it "should delete a bookmark" do
      delete "/api/#{API_VERSION}/bookmarks/#{@id}"
      last_response.should be_ok
      get "/api/#{API_VERSION}/bookmarks/#{@id}"
      last_response.status.should == 404
    end
  end
end