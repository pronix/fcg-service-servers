require File.dirname(__FILE__) + '/spec_helper'

describe "Rating App" do
  before(:each) do
    Rating.delete_all
    RatingRecord.delete_all
  end
  
  describe "GET on /api/#{API_VERSION}/ratings/:id" do
    before(:each) do
      @rating = Fabricate(:rating)
      @id = @rating.id.to_s
    end
    
    it "should return an rating by id: #{@id}" do
      get "/api/#{API_VERSION}/ratings/#{@id}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["id"].should == @id
    end
    
    it "should return a 404 for a rating that doesn't exist" do
      get "/api/#{API_VERSION}/ratings/foo"
      last_response.status.should == 404
      last_response.body.should == "rating not found".to_msgpack
    end
  end
  
  describe "GET on /api/#{API_VERSION}/ratings/record/:record" do
    before(:each) do
      @rating = Fabricate(:rating)
      1.upto(25){|i| Fabricate("rating_#{i}".to_sym) }
    end
    
    it "should return a score and count for a rating record" do
      get "/api/#{API_VERSION}/ratings/record/#{@rating.record}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["rating_count"].should == 26
      attributes["score_average"].should > 1.0
    end
  end
  
  describe "POST on /api/#{API_VERSION}/ratings" do
    it "should create a rating" do
      rating = {
        :record       => "post:4c43475fffefad982a00001a",
        :user_id      => "4c43475fff808d982a00001a",
        :score        => 4
      }
      post "/api/#{API_VERSION}/ratings", rating.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      get "/api/#{API_VERSION}/ratings/#{attributes["id"]}"
      attributes = MessagePack.unpack(last_response.body)
      attributes["record"].should == rating[:record]
      attributes["user_id"].should      == rating[:user_id]
      attributes["score"].should        == rating[:score]
    end
    
    it "should not allow rating outside of range" do
      rating = {
        :record  => "post:4c43475fffefad982a00001a",
        :user_id       => "4c43475fff808d982a00001a",
        :score         => 9
      }
      post "/api/#{API_VERSION}/ratings", rating.to_msgpack
      last_response.should_not be_ok
      attributes = MessagePack.unpack(last_response.body)
    end
  end

  describe "PUT on /api/#{API_VERSION}/ratings/:id" do
    before(:each) do
      @rating = Fabricate(:rating)
      @id = @rating.id.to_s
    end
    
    it "should update a rating" do
      rating = {
        :score => 1
      }
      put "/api/#{API_VERSION}/ratings/#{@id}", rating.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["score"].should == rating[:score]
    end
  end
  
  describe "DELETE on /api/#{API_VERSION}/ratings/:id" do
    before(:each) do
      @rating = Fabricate(:rating)
      @id = @rating.id.to_s
    end
    
    it "should delete a rating" do
      delete "/api/#{API_VERSION}/ratings/#{@id}"
      last_response.should be_ok
      get "/api/#{API_VERSION}/ratings/#{@id}"
      last_response.status.should == 404
    end
  end
end