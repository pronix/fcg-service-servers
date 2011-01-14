require File.dirname(__FILE__) + '/spec_helper'

describe "Activity App" do
  
  before(:each) do
    acts = JobState.find(:all)
    acts.each{|a| a.delete }
  end

  describe "GET on /activities/:id" do
    before(:each) do
      @activity = Fabricate(:activity)
      @id = @activity.id.to_s
    end
    
    it "should return an activity by id: #{@id}" do
      get "/activities/#{@id}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["page"].should == @activity.page
    end

    it "should return a activity with an verb" do
      get "/activities/#{@id}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["verb"].should == @activity.verb
    end

    it "should return site" do
      get "/activities/#{@id}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["site"].should == "alltheparties.com"
    end

    it "should return proper id" do
      get "/activities/#{@id}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["id"].should == @id
    end
    
    it "should return a 404 for a activity that doesn't exist" do
      get "/activities/foo"
      last_response.status.should == 404
    end
  end
  
  describe "POST on /activities" do
    it "should create a activity" do
      activity = {
        :user_id => "4c43475fff808d982a00001a",
        :verb => "click",
        :object_type => "city",
        :title => "Test title",
        :page => "/events",
        :city => "nyc",
        :site => "ATP"
      }
        
      post "/activities", activity.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      get "/activities/#{attributes["id"]}"
      attributes = MessagePack.unpack(last_response.body)
      attributes["object_type"].should == activity[:object_type]
    end
  end

  describe "DELETE on /activities/:id" do
    before(:each) do
      @activity = Fabricate(:activity)
      @id = @activity.id.to_s
    end
    
    it "should delete a activity" do
      delete "/activities/#{@id}"
      last_response.should be_ok
      get "/activities/#{@id}"
      last_response.status.should == 404
    end
  end
end
