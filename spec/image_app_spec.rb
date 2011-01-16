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
      attributes["types"].should == @image.types
      attributes["album_id"].should == @image.album_id
    end
    
    it "should return a 404 for an image that doesn't exist" do
      get "/images/foo"
      last_response.status.should == 404
    end
  end

  describe "GET on /images/by_ids" do
    before(:each) do
      @image = Fabricate(:image, :album_id => @album.id)
      @id = @image.id.to_s
    end

    it "should return 2 images by ids" do
      image = {
        :user_id    => "4c4a475fff808d982af0001a",
        :types      => FCG_CONFIG.image.flyer,
        :album_id   => @album.id.to_s,
        :urls       => "localhost/images/img.png",
        :sizes      => 1024
      }
      post "/images", image.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      id2 = attributes["id"]

      get "/images/by_ids", :ids => "#{@id},#{id2}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes.class == Array
      attributes.length == 2
      (attributes[0]["id"] == @id || attributes[0]["id"] == id2).should == true
      (attributes[1]["id"] == @id || attributes[1]["id"] == id2).should == true
    end

    it "should return one image by 2 same ids" do
      image = {
        :user_id    => "4c4a475fff808d982af0001a",
        :types      => FCG_CONFIG.image.user,
        :album_id   => @album.id.to_s,
        :urls       => "localhost/images/img2.png",
        :sizes      => 1024
      }
      post "/images", image.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      id2 = attributes["id"]

      get "/images/by_ids", :ids => "#{@id},#{@id}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes.class == Array
      attributes.length == 1
      attributes[0]["id"].should == @id
    end

    it "should return one image by one valid id, one non-existed id" do
      get "/images/by_ids", :ids => "#{@id},#{@id.gsub("0", "1")}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes.class == Array
      attributes.length == 1
      attributes[0]["id"].should == @id
    end

    it "should return a 404 for invalid ids" do
      get "/images/by_ids", :ids => "foo,foo1"
      last_response.status.should == 404
    end
  end
  
  describe "POST on /images" do
    it "should create a image" do
      image = {
        :user_id    => "4c4a475fff808d982af0001a",
        :types      => FCG_CONFIG.image.user,
        :album_id   => @album.id.to_s,
        :urls       => "localhost/images/img2.png",
        :sizes      => 1024
      }
      post "/images", image.to_msgpack
      
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      get "/images/#{attributes["id"]}"
      attributes = MessagePack.unpack(last_response.body)
      attributes["user_id"].should == image[:user_id]
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
      hash = { :caption => "new caption" }
      put "/images/#{@id}", hash.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["caption"].should == hash[:caption]
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