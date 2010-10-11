require File.dirname(__FILE__) + '/spec_helper'

describe "Message App" do
  before(:each) do
    Message.delete_all
  end
  
  describe "GET on /api/#{API_VERSION}/messages/:id" do
    before(:each) do
      @message = Fabricate(:message)
      @id = @message.id.to_s
    end
    
    it "should return an message by id: #{@id}" do
      get "/api/#{API_VERSION}/messages/#{@id}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["id"].should == @id
      attributes["sender_id"].should            == @message.sender_id
      attributes["receiver_id"].should          == @message.receiver_id  
      attributes["body"].should                 == @message.body  
      attributes["body_as_html"].should         == text_as_html(attributes["body"])    
      attributes["viewable_by_sender"].should   be_true
      attributes["viewable_by_receiver"].should be_true
    end
    
    it "should return a 404 for a message that doesn't exist" do
      get "/api/#{API_VERSION}/messages/foo"
      last_response.status.should == 404
      last_response.body.should == "message not found".to_msgpack
    end
  end
  
  describe "POST on /api/#{API_VERSION}/messages" do
    it "should create a message" do
      message = {
        :sender_id   => new_user_id,
        :receiver_id => new_user_id,
        :body        => Faker::Lorem.paragraph(5)
      }
      post "/api/#{API_VERSION}/messages", message.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      get "/api/#{API_VERSION}/messages/#{attributes["id"]}"
      attributes = MessagePack.unpack(last_response.body)
      attributes["sender_id"].should            == message[:sender_id]
      attributes["receiver_id"].should          == message[:receiver_id]  
      attributes["body"].should                 == message[:body]
      attributes["body_as_html"].should         == text_as_html(message[:body])    
      attributes["viewable_by_sender"].should   be_true
      attributes["viewable_by_receiver"].should be_true
    end
  end

  describe "PUT on /api/#{API_VERSION}/messages/:id" do
    before(:each) do
      @message = Fabricate(:message)
      @id = @message.id.to_s
    end
    
    it "should update a message" do
      message = {
        :body => Faker::Lorem.paragraph(5),
        :viewable_by_receiver => false
      }
      put "/api/#{API_VERSION}/messages/#{@id}", message.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["viewable_by_receiver"].should be_false
      attributes["body_as_html"].should == text_as_html(message[:body])  
    end
  end
  
  describe "DELETE on /api/#{API_VERSION}/messages/:id" do
    before(:each) do
      @message = Fabricate(:message)
      @id = @message.id.to_s
    end
    
    it "should delete a message" do
      delete "/api/#{API_VERSION}/messages/#{@id}"
      last_response.should be_ok
      get "/api/#{API_VERSION}/messages/#{@id}"
      last_response.status.should == 404
    end
  end
end