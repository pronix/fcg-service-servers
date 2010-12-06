require File.dirname(__FILE__) + '/spec_helper'

describe "JobState App" do
  before(:each) do
    obs = JobState.find(:all)
    obs.each{|o| o.delete }
  end
  
  after(:all) do
    SimpleRecord.close_connection
  end
  
  describe "GET on /job_states/:id" do
    before(:each) do
      @job_state = Fabricate(:job_state)
      @id = @job_state.id.to_s
    end
    
    it "should return an job_state by id: #{@id}" do
      sleep 1
      get "/job_states/#{@id}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["id"].should == @id
    end
    
    it "should return a 404 for a job_state that doesn't exist" do
      get "/job_states/foo"
      last_response.status.should == 404
      last_response.body.should == "job_state not found".to_msgpack
    end
  end
  
  describe "POST on /job_states" do
    it "should create a job_state" do
      job_state = {
        :state  => "created",
        :polled => 0,
        :site   => "test.local:8080"
      }
      post "/job_states", job_state.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      sleep 1
      get "/job_states/#{attributes["id"]}"
      attributes = MessagePack.unpack(last_response.body)
    end
  end

  describe "PUT on /job_states/:id" do
    before(:each) do
      @job_state = Fabricate(:job_state)
      @id = @job_state.id.to_s
    end
    
    it "should update a job_state" do
      job_state = {
        :polled => 1
      }
      put "/job_states/#{@id}", job_state.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["polled"].should == 1
    end
  end
  
  describe "DELETE on /job_states/:id" do
    before(:each) do
      @job_state = Fabricate(:job_state)
      @id = @job_state.id.to_s
    end
    
    it "should delete a job_state" do
      sleep 1
      delete "/job_states/#{@id}"
      last_response.should be_ok
      sleep 1
      get "/job_states/#{@id}"
      last_response.status.should == 404
    end
  end
end