require File.dirname(__FILE__) + '/spec_helper'

describe "Party App" do
  before(:each) do
    User.delete_all
    Party.delete_all
    Venue.delete_all
    Event.delete_all
    @user = Fabricate(:user)
  end

  describe "GET on /parties/:id" do
    before(:each) do
      @venue  = Fabricate(:venue, :user_id => @user.id)
      @party  = Fabricate(:party, :venue => @venue.to_hash, :user_id => @user.id.to_s)
      @id     = @party.id.to_s
    end
    
    it "should return an party by id: #{@id}" do
      get "/parties/#{@id}"
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["id"].should == @id
      date = (Date.today + 7).slashed
      attributes["next_date"] == date
      attributes["start_time"] == "10:00pm"
      attributes["end_time"] == "4:00am"
      attributes["events"].should include(Date.parse(date).to_s)
      attributes["venue"].keys.sort.should == @venue.to_hash.keys.sort
      attributes["venue"].each_pair do |key, value|
        value.should == @venue.to_hash[key] unless ["created_at", "updated_at"].include?(key)
      end
      
      # Timecop.travel(Time.now + 30.days) do
      #   get "/parties/#{@id}"
      #   last_response.should be_ok
      #   attributes = MessagePack.unpack(last_response.body)
      # end
    end
    
    it "should return a 404 for a party that doesn't exist" do
      get "/parties/foo"
      last_response.status.should == 404
    end
  end 
  
  describe "POST on /parties" do
    before(:each) do
      
      @venue  = Fabricate(:venue)
    end
    
    it "should create a party" do
      date = (Date.today + 14).to_s
      party = {
        :title        => "Prada Launch Party",
        :next_date    => date,
        :start_time   => "10:00pm",
        :end_time     => "2:00am",
        :music        => "R&B",
        :description  => Faker::Lorem.paragraphs(1),
        :user_id      => @user.id.to_s,
        :venue_id     => @venue.id.to_s
      }
      
      post "/parties", party.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      get "/parties/#{attributes["id"]}"
      attributes = MessagePack.unpack(last_response.body)
      attributes["title"].should == party[:title]
      attributes["user_id"].should == @user.id.to_s
      attributes["venue"]["id"].should == @venue.id.to_s
      attributes["venue"]["citycode"].should == "nyc"
      attributes["length_in_hours"].should == 4.0
      next_date = Date.parse(attributes["next_date"])
    end
  end

  describe "PUT on /parties/:id" do
    before(:each) do
      @venue  = Fabricate(:lounge, :user_id => @user.id)
      @venue2 = Fabricate(:venue,  :user_id => @user.id)
      @party  = Fabricate(:party, :venue => @venue.to_hash, :user_id => @user.id)
      @id     = @party.id.to_s
    end
    
    it "should update a party" do
      old_next_date = @party.next_date
      date = (Date.today + 14).to_s
      new_title = "#{Faker::Company.name} Launch Party"
      put "/parties/#{@id}", { :title => new_title, :next_date => date }.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["title"].should == new_title
      attributes["next_date"].should == date
      attributes["events"].keys.size.should == 2
      old_event = Event.find(attributes["events"][old_next_date.to_s])
      old_event.active.should be_false
      event = Event.find(attributes["events"][date])
      event.active.should be_true
    end
    
    it "should change the party venue" do
      put "/parties/#{@id}", { :venue => @venue2.to_hash }.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes["venue"].each_pair do |key, value|
        value.should == @venue2.to_hash[key] unless ["created_at", "updated_at"].include?(key)
      end
      attributes["venue"]["time_zone"].should_not == @party.venue["time_zone"]
    end
  end
  
  describe "DELETE on /parties/:id" do
    before(:each) do
      @venue = Fabricate(:venue, :user_id => @user.id)
      @party = Fabricate(:party, :venue => @venue.to_hash, :user_id => @user.id)
      @id = @party.id.to_s
    end
    
    it "should delete a party" do
      delete "/parties/#{@id}"
      last_response.should be_ok
      get "/parties/#{@id}"
      last_response.status.should == 404
    end
  end
end