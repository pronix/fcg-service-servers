require File.dirname(__FILE__) + '/spec_helper'

describe "Post App" do
  before(:each) do
    Post.delete_all
  end
  
  describe "GET on /api/#{API_VERSION}/posts/:id" do
    before(:each) do
      @post = Fabricate(:post)
      @id = @post.id.to_s
    end
    
    it "should return an post by id: #{@id}" do
      get "/api/#{API_VERSION}/posts/#{@id}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["id"].should == @id
      attributes["title"].should == "this is the sample title"
      attributes["username"].should == "sdj"
      attributes["display_name"].should == "Sammy Davis Jr."
      attributes.should include("body_html")
      attributes.should include("version")
    end
    
    it "should return a 404 for a post that doesn't exist" do
      get "/api/#{API_VERSION}/posts/foo"
      last_response.status.should == 404
    end
  end
  
  describe "POST on /api/#{API_VERSION}/posts" do
    it "should create a post" do
      post = { 
        :site            => "flyerdeep.com",
        :title           => "Stand on your feet and sing!",
        :user_id         => "4c43475fd3808d982a00001a",
        :body            => Faker::Lorem.sentences(3).to_s,
        :display_name    => "Faith Evans",
        :username        => "faith"
      }
      post "/api/#{API_VERSION}/posts", post.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      get "/api/#{API_VERSION}/posts/#{attributes["id"]}"
      attributes = MessagePack.unpack(last_response.body)
      attributes["username"].should == "faith"
      attributes["site"].should == "flyerdeep.com"
      attributes["title"].should == "Stand on your feet and sing!"
      attributes["username"].should == "faith"
      attributes["display_name"].should == "Faith Evans"
    end
  end

  describe "PUT on /api/#{API_VERSION}/posts/:id" do
    before(:each) do
      @post = Fabricate(:post)
      @id = @post.id.to_s
    end
    
    it "should update a post" do
      hash = { :body => "Ain't this some sh*t!" }
      put "/api/#{API_VERSION}/posts/#{@id}", hash.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["body"].should == hash[:body]
    end
  end
  
  describe "DELETE on /api/#{API_VERSION}/posts/:id" do
    before(:each) do
      @post = Fabricate(:post)
      @id = @post.id.to_s
    end
    
    it "should delete a post" do
      delete "/api/#{API_VERSION}/posts/#{@id}"
      last_response.should be_ok
      get "/api/#{API_VERSION}/posts/#{@id}"
      last_response.status.should == 404
    end
  end
end