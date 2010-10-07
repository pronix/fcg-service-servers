require File.dirname(__FILE__) + '/spec_helper'

describe "Album App" do
  before(:each) do
    Album.delete_all
  end
  
  describe "GET on /api/#{API_VERSION}/albums/:id" do
    before(:each) do
      @album = Fabricate(:album)
      @id = @album.id.to_s
    end
    
    it "should return an album by id: #{@id}" do
      get "/api/#{API_VERSION}/albums/#{@id}"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["_id"].should == @id
    end
    
    it "should return a 404 for a album that doesn't exist" do
      get "/api/#{API_VERSION}/albums/foo"
      last_response.status.should == 404
    end
  end
  
  describe "POST on /api/#{API_VERSION}/albums" do
    it "should create a album" do
      raise "create hash"
      album = { }
      post "/api/#{API_VERSION}/albums", album.to_json
      
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      get "/api/#{API_VERSION}/albums/#{attributes['_id']}"
      attributes = JSON.parse(last_response.body)
    end
  end

  describe "PUT on /api/#{API_VERSION}/albums/:id" do
    before(:each) do
      @album = Fabricate(:album)
      @id = @album.id.to_s
    end
    
    it "should update a album" do
      pending do
        raise "create hash"
        hash = { }
        put "/api/#{API_VERSION}/albums/#{@id}", hash.to_json
        last_response.should be_ok
        attributes = JSON.parse(last_response.body)
        get "/api/#{API_VERSION}/albums/#{@id}"
        attributes = JSON.parse(last_response.body)
      end
    end
  end
  
  describe "DELETE on /api/#{API_VERSION}/albums/:id" do
    before(:each) do
      @album = Fabricate(:album)
      @id = @album.id.to_s
    end
    
    it "should delete a album" do
      delete "/api/#{API_VERSION}/albums/#{@id}"
      last_response.should be_ok
      get "/api/#{API_VERSION}/albums/#{@id}"
      last_response.status.should == 404
    end
  end
end