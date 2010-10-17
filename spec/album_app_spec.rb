require File.dirname(__FILE__) + '/spec_helper'

describe "Album App" do
  before(:each) do
    Album.delete_all
  end
  
  describe "GET on /albums/:id" do
    before(:each) do
      @album = Fabricate(:album)
      @id = @album.id.to_s
    end
    
    it "should return an album by id: #{@id}" do
      get "/albums/#{@id}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["id"].should == @id
      attributes["title"].split(/ /).size.should == 12
      attributes["user_id"].should == "4c43475fff808d982a00001a"
      yesterday = (Date.today - 1)
      attributes["date"].should == yesterday.to_s
    end
    
    it "should return a 404 for a album that doesn't exist" do
      get "/albums/foo"
      last_response.status.should == 404
    end
  end
  
  describe "POST on /albums" do
    it "should create a album" do
      two_weeks_ago = (Date.today - 14).to_s
      album = { :title => "Sharon Angle is blah blah blah", :user_id => "4c43475fff808d982a00001f", :date => two_weeks_ago, :record => "event:#{new_id}"  }
      post "/albums", album.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["title"].should     == album[:title]
      attributes["user_id"].should   == album[:user_id]
      attributes["date"].should      == album[:date]
    end
    
    it "should not create an album that has a future date" do
      two_weeks_since = (Date.today + 14).slashed
      album = { :title => "Sharon Angle is blah blah blah", :user_id => "4c43475fff808d982a00001f", :date => two_weeks_since, :record => "event:#{new_id}" }
      post "/albums", album.to_msgpack
      last_response.should_not be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["errors"].keys.should == ["date"]
    end
    
  end

  describe "PUT on /albums/:id" do
    before(:each) do
      @album = Fabricate(:album)
      @id = @album.id.to_s
    end
    
    it "should update a album" do
      today = (Date.today - 30).to_s
      album = { :title => "What are you going to do?", :date => today }
      put "/albums/#{@id}", album.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["title"].should  == album[:title]
      attributes["date"].should   == album[:date]
      @album.title.should_not     == attributes["title"]
      @album.date.should_not      == attributes["date"]
    end
  end
  
  describe "DELETE on /albums/:id" do
    before(:each) do
      @album = Fabricate(:album)
      @id = @album.id.to_s
    end
    
    it "should delete a album" do
      delete "/albums/#{@id}"
      last_response.should be_ok
      get "/albums/#{@id}"
      last_response.status.should == 404
    end
  end
end