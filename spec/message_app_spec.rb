require File.dirname(__FILE__) + '/spec_helper'

describe "Message App" do
  before(:each) do
    Message.delete_all
  end
  
  describe "GET on /messages/:id" do
    before(:each) do
      @message = Fabricate(:message)
      @id = @message.id.to_s
    end
    
    it "should return an message by id: #{@id}" do
      get "/messages/#{@id}"
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
      get "/messages/foo"
      last_response.status.should == 404
      last_response.body.should == "message not found".to_msgpack
    end
  end
  
  describe "POST on /messages" do
    it "should create a message" do
      message = {
        :sender_id   => new_id,
        :receiver_id => new_id,
        :body        => Faker::Lorem.paragraph(5)
      }
      post "/messages", message.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      get "/messages/#{attributes["id"]}"
      attributes = MessagePack.unpack(last_response.body)
      attributes["sender_id"].should            == message[:sender_id]
      attributes["receiver_id"].should          == message[:receiver_id]  
      attributes["body"].should                 == message[:body]
      attributes["body_as_html"].should         == text_as_html(message[:body])    
      attributes["viewable_by_sender"].should   be_true
      attributes["viewable_by_receiver"].should be_true
    end
  end

  describe "PUT on /messages/:id" do
    before(:each) do
      @message = Fabricate(:message)
      @id = @message.id.to_s
    end
    
    it "should update a message" do
      message = {
        :body => Faker::Lorem.paragraph(5),
        :viewable_by_receiver => false
      }
      put "/messages/#{@id}", message.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["viewable_by_receiver"].should be_false
      attributes["body_as_html"].should == text_as_html(message[:body])  
    end
  end
  
  describe "DELETE on /messages/:id" do
    before(:each) do
      @message = Fabricate(:message)
      @id = @message.id.to_s
    end
    
    it "should delete a message" do
      delete "/messages/#{@id}"
      last_response.should be_ok
      get "/messages/#{@id}"
      last_response.status.should == 404
    end
  end
end