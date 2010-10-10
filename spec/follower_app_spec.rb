require File.dirname(__FILE__) + '/spec_helper'

describe "Follower App" do
  before(:each) do
    Follower.delete_all
    User.delete_all
  end
  
  describe "GET on /api/#{API_VERSION}/followers/:id" do
    before(:each) do
      @user = Fabricate(:user)
      @follower = Fabricate(:follower, :leader_id => @user.id)
      @id = @follower.id.to_s
    end
    
    it "should return an follower by id: #{@id}" do
      get "/api/#{API_VERSION}/followers/#{@id}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["id"].should == @id
      attributes["leader_id"].should == @follower.leader_id
      attributes["follower_id"].should == @follower.follower_id
      attributes["approved"].should be_false
    end
    
    it "should return a 404 for a follower that doesn't exist" do
      get "/api/#{API_VERSION}/followers/foo"
      last_response.status.should == 404
      last_response.body.should == "follower not found".to_msgpack
    end
  end
  
  describe "POST on /api/#{API_VERSION}/followers" do
    it "should create a follower" do
      follower = {
        :leader_id => new_user_id,
        :follower_id => new_user_id
      }
      post "/api/#{API_VERSION}/followers", follower.to_msgpack

      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      get "/api/#{API_VERSION}/followers/#{attributes["id"]}"
      attributes = MessagePack.unpack(last_response.body)
      attributes["leader_id"].should == follower[:leader_id]
      attributes["follower_id"].should == follower[:follower_id]
      attributes["approved"].should be_true
    end
  end

  describe "PUT on /api/#{API_VERSION}/followers/:id" do
    before(:each) do
      @follower = Fabricate(:follower)
      @id = @follower.id.to_s
    end
    
    it "should update a follower" do
      follower = {
        :approved => true
      }
      @follower.approved.should be_false
      put "/api/#{API_VERSION}/followers/#{@id}", follower.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["approved"].should be_true
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