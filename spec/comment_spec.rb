require File.dirname(__FILE__) + '/spec_helper'

describe "Comment App" do
  before(:each) do
    Comment.delete_all
  end
  
  describe "GET on /api/#{API_VERSION}/comments/:id" do
    before(:each) do
      @comment = Fabricate(:comment)
      @id = @comment.id.to_s
    end
    
    it "should return an comment by id: #{@id}" do
      get "/api/#{API_VERSION}/comments/#{@id}"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["_id"].should == @id
    end
    
    it "should return a 404 for a comment that doesn't exist" do
      get "/api/#{API_VERSION}/comments/foo"
      last_response.status.should == 404
    end
  end
  
  describe "POST on /api/#{API_VERSION}/comments" do
    it "should create a comment" do
      comment = { }
      post "/api/#{API_VERSION}/comments", comment.to_json
      
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      get "/api/#{API_VERSION}/comments/#{attributes['_id']}"
      attributes = JSON.parse(last_response.body)
    end
  end

  describe "PUT on /api/#{API_VERSION}/comments/:id" do
    before(:each) do
      @comment = Fabricate(:comment)
      @id = @comment.id.to_s
    end
    
    it "should update a comment" do
      hash = { }
      put "/api/#{API_VERSION}/comments/#{@id}", hash.to_json
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      get "/api/#{API_VERSION}/comments/#{@id}"
      attributes = JSON.parse(last_response.body)
    end
  end
  
  describe "DELETE on /api/#{API_VERSION}/comments/:id" do
    before(:each) do
      @comment = Fabricate(:comment)
      @id = @comment.id.to_s
    end
    
    it "should delete a comment" do
      delete "/api/#{API_VERSION}/comments/#{@id}"
      last_response.should be_ok
      get "/api/#{API_VERSION}/comments/#{@id}"
      last_response.status.should == 404
    end
  end
end