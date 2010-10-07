require File.dirname(__FILE__) + '/spec_helper'

describe "Image App" do
  before(:each) do
    Image.delete_all
    @album = Fabricate(:album)
  end
  
  describe "GET on /api/#{API_VERSION}/images/:id" do
    before(:each) do
      @image = Fabricate(:image, :album_id => @album.id)
      @id = @image.id.to_s
    end
    
    it "should return an image by id: #{@id}" do
      get "/api/#{API_VERSION}/images/#{@id}"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["_id"].should == @id
      attributes["user_id"].should == @image.user_id
      attributes["state"].should == "new"
      attributes["types"].should == @image.types
      attributes["album_id"].should == @image.album_id
    end
    
    it "should return a 404 for an image that doesn't exist" do
      get "/api/#{API_VERSION}/images/foo"
      last_response.status.should == 404
    end
  end
  
  describe "POST on /api/#{API_VERSION}/images" do
    it "should create a image" do
      image = {
        :user_id    => "4c4a475fff808d982af0001a",
        :types      => FCG_CONFIG.image.flyer,
        :album_id   => @album.id.to_s
      }
      post "/api/#{API_VERSION}/images", image.to_json
      
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      get "/api/#{API_VERSION}/images/#{attributes['_id']}"
      attributes = JSON.parse(last_response.body)
      attributes["user_id"].should == image[:user_id]
      attributes["state"].should == "new"
      attributes["types"].should == image[:types]
      attributes["album_id"].should == image[:album_id]
    end
  end

  describe "PUT on /api/#{API_VERSION}/images/:id" do
    before(:each) do
      @image = Fabricate(:image, :album_id => @album.id)
      @id = @image.id.to_s
    end
    
    it "should update a image" do
      pending do
        hash = { :state => "completed" }
        put "/api/#{API_VERSION}/images/#{@id}", hash.to_json
        last_response.should be_ok
        attributes = JSON.parse(last_response.body)
        attributes["state"].should_not == "completed"
      end
    end
  end
  
  describe "DELETE on /api/#{API_VERSION}/images/:id" do
    before(:each) do
      @image = Fabricate(:image, :album_id => @album.id)
      @id = @image.id.to_s
    end
    
    it "should delete a image" do
      delete "/api/#{API_VERSION}/images/#{@id}"
      last_response.should be_ok
      get "/api/#{API_VERSION}/images/#{@id}"
      last_response.status.should == 404
    end
  end
end