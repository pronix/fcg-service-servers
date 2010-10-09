require File.dirname(__FILE__) + '/spec_helper'

describe "Follower App" do
  before(:each) do
    Follower.delete_all
  end
  
  describe "GET on /api/#{API_VERSION}/followers/:id" do
    before(:each) do
      @follower = Fabricate(:follower)
      @id = @follower.id.to_s
    end
    
    it "should return an follower by id: #{@id}" do
      pending do
        get "/api/#{API_VERSION}/followers/#{@id}"
        last_response.should be_ok
        attributes = MessagePack.unpack(last_response.body)
        attributes["id"].should == @id
      end
    end
    
    it "should return a 404 for a follower that doesn't exist" do
      pending do
        get "/api/#{API_VERSION}/followers/foo"
        last_response.status.should == 404
        last_response.body.should == "follower not found".to_msgpack
      end
    end
  end
  
  describe "POST on /api/#{API_VERSION}/followers" do
    it "should create a follower" do
      pending do
        follower = {
          
        }
        post "/api/#{API_VERSION}/followers", follower.to_msgpack

        last_response.should be_ok
        attributes = MessagePack.unpack(last_response.body)
        get "/api/#{API_VERSION}/followers/#{attributes["id"]}"
        attributes = MessagePack.unpack(last_response.body)
      end
    end
  end

  describe "PUT on /api/#{API_VERSION}/followers/:id" do
    before(:each) do
      @follower = Fabricate(:follower)
      @id = @follower.id.to_s
    end
    
    it "should update a follower" do
      pending do
        follower = {
          
        }
        put "/api/#{API_VERSION}/followers/#{@id}", follower.to_msgpack
        last_response.should be_ok
        attributes = MessagePack.unpack(last_response.body)
      end
    end
  end
  
  describe "DELETE on /api/#{API_VERSION}/followers/:id" do
    before(:each) do
      @follower = Fabricate(:follower)
      @id = @follower.id.to_s
    end
    
    it "should delete a follower" do
      delete "/api/#{API_VERSION}/followers/#{@id}"
      last_response.should be_ok
      get "/api/#{API_VERSION}/followers/#{@id}"
      last_response.status.should == 404
    end
  end
end