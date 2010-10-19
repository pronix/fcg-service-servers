require File.dirname(__FILE__) + '/spec_helper'

describe "Search" do
  before(:each) do
    Album.delete_all
    1.upto(20) do |i|
      Fabricate(:album_template, :record => "user:#{new_id}", :date => Date.today - 2 * i, :image_type => "flyer")
    end
    @album = Fabricate(:album)
    @id = @album.id.to_s
  end

  describe "POST on /albums/search" do
    it "should return an array containing 1 album" do
      search_hash = {"conditions" => { "image_type"=>"event" }, "limit"=>20, "skip"=>0}
      post "/albums/search", search_hash.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes.should be_a_kind_of(Array)
      attributes.size.should == 1
      attributes.first["id"].should == @id
    end
    
    it "should return an array containing 20 albums" do
      search_hash = {"conditions" => { "image_type"=>"flyer" }, "limit"=>20, "skip"=>0}
      post "/albums/search", search_hash.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes.should be_a_kind_of(Array)
      attributes.size.should == 20
    end
    
    it "should return an empty array" do
      search_hash = {"conditions" => { "image_type"=>"events" }, "limit"=>20, "skip"=>0}
      post "/albums/search", search_hash.to_msgpack
      last_response.should be_ok
      attributes = MessagePack.unpack(last_response.body)
      attributes.should be_a_kind_of(Array)
      attributes.size.should == 0
    end
  end
end