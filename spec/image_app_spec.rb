require File.dirname(__FILE__) + '/spec_helper'

describe "Image App" do
  before(:each) do
    Image.delete_all
    @album = Fabricate(:album)
  end
  
  describe "GET on /images/:id" do
    before(:each) do
      @image = Fabricate(:image, :album_id => @album.id)
      @id = @image.id.to_s
    end
    
    it "should return an image by id: #{@id}" do
      get "/images/#{@id}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["id"].should == @id
      attributes["user_id"].should == @image.user_id
      attributes["state"].should == "new"
      attributes["types"].should == @image.types
      attributes["album_id"].should == @image.album_id
    end
    
    it "should return a 404 for an image that doesn't exist" do
      get "/images/foo"
      last_response.status.should == 404
    end
  end
  
  describe "POST on /images" do
    it "should create a image" do
      image = {
        :user_id    => "4c4a475fff808d982af0001a",
        :types      => FCG_CONFIG.image.flyer,
        :album_id   => @album.id.to_s
      }
      post "/images", image.to_msgpack
      
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      get "/images/#{attributes["id"]}"
      attributes = MessagePack.unpack(last_response.body)
      attributes["user_id"].should == image[:user_id]
      attributes["state"].should == "new"
      attributes["types"].should == image[:types]
      attributes["album_id"].should == image[:album_id]
    end
  end

  describe "PUT on /images/:id" do
    before(:each) do
      @image = Fabricate(:image, :album_id => @album.id)
      @id = @image.id.to_s
    end
    
    it "should update a image" do
      hash = { :state => "completed" }
      put "/images/#{@id}", hash.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["state"].should == "new"
      attributes["state"].should_not == "completed"
    end
  end
  
  describe "DELETE on /images/:id" do
    before(:each) do
      @image = Fabricate(:image, :album_id => @album.id)
      @id = @image.id.to_s
    end
    
    it "should delete a image" do
      delete "/images/#{@id}"
      last_response.should be_ok
      get "/images/#{@id}"
      last_response.status.should == 404
    end
  end
end