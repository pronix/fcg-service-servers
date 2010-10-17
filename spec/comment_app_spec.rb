require File.dirname(__FILE__) + '/spec_helper'

describe "Comment App" do
  before(:each) do
    Comment.delete_all
  end
  
  describe "GET on /comments/:id" do
    before(:each) do
      @comment = Fabricate(:comment)
      @id = @comment.id.to_s
    end
    
    it "should return an comment by id: #{@id}" do
      get "/comments/#{@id}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["id"].should == @id
      attributes["record"].should  == "feed:4c43475fff808d982a00001a"
      attributes["body_as_html"].should      == RDiscount.new(attributes["body"], :smart, :autolink).to_html
      attributes["displayed_name"].should == "Sammy Davis Jr."
      attributes["user_id"].should        == "4c43475fdf808f982a00001a"
    end
    
    it "should return a 404 for a comment that doesn't exist" do
      get "/comments/foo"
      last_response.status.should == 404
    end
  end
  
  describe "POST on /comments" do
    it "should create a comment" do
      comment = {
        :site            => "alltheparties.com",
        :record   => "feed:4c43475fff808d982a00001a",
        :body            => "Ain't this some bullshit\n\nCheck me at www.twitter.com/fccgedv",
        :displayed_name  => "Sammy Davis Jr.",
        :user_id         => "4c43475fdf808f982a00001a"
      }
      post "/comments", comment.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      get "/comments/#{attributes["id"]}"
      attributes = MessagePack.unpack(last_response.body)
      attributes["body"].should == comment[:body]
    end
  end

  describe "PUT on /comments/:id" do
    before(:each) do
      @comment = Fabricate(:comment)
      @id = @comment.id.to_s
    end
    
    it "should update a comment" do
      hash = { :body => "Solid Bull Crappo!"}
      put "/comments/#{@id}", hash.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes.should == attributes
      attributes["body"].should == hash[:body]
    end
  end
  
  describe "DELETE on /comments/:id" do
    before(:each) do
      @comment = Fabricate(:comment)
      @id = @comment.id.to_s
    end
    
    it "should delete a comment" do
      delete "/comments/#{@id}"
      last_response.should be_ok
      get "/comments/#{@id}"
      last_response.status.should == 404
    end
  end
end