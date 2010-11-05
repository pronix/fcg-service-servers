require File.dirname(__FILE__) + '/spec_helper'

describe "Stat App" do
  before(:each) do
    @stats = mock('stats')
    
  end
  
  describe "GET on /stats/:id" do
    before(:each) do
      # @stat = @stat
      # MyModel.should_receive(:find).with(id).and_return(@mock_model_instance)
      
    end
    
    it "should return stats from /stats/most_visited" do
      get "/stats/most_visited"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes.should == []
      last_response.body.should == [].to_msgpack
    end
  end
end