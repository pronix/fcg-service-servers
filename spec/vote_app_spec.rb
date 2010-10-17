require File.dirname(__FILE__) + '/spec_helper'

describe "Vote App" do
  before(:each) do
    Vote.delete_all
  end
  
  describe "POST on /votes" do
    it "should create a vote" do
      vote = {
        :record  => "post:4c43475fffefad982a00001a",
        :user_id       => "4c43475fff808d982a00001a",
        :state         => "up"
      }
      post "/votes", vote.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["user_id"].should == "4c43475fff808d982a00001a"
      attributes["record"].should == "post:4c43475fffefad982a00001a"
      attributes["state"].should == "up"
    end
  end
  
  describe "DELETE on /votes/:id" do
    before(:each) do
      @vote = Fabricate(:vote)
      @id = @vote.id.to_s
    end
    
    it "should delete a vote" do
      delete "/votes/#{@id}"
      last_response.should be_ok
      get "/votes/#{@id}"
      last_response.status.should == 404
    end
  end
end