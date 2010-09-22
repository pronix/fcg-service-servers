require File.dirname(__FILE__) + '/test_helper'

def app
  FCG::Service::ActivityApp
end

describe "activity_app" do
  before(:each) do
    Activity.delete_all
  end

  describe "GET on /api/#{API_VERSION}/activities/:id" do
    before(:each) do
      act = Activity.create(
        :actor => {
          :display_name => "Paul Dix",
          :url => "http://www.fcgid.com/person/paulDiddy", 
          :photo => nil
        },
        :target => {
          :title => "in the photo album (Mon, Jul 19: Salladin at Marquee (Solid))",
          :thumbnail => "http://destroy_later_blah_blah_blah.s3.amazonaws.com/alltheparties.com//cd772554-d709-988a-2472-cdd9b5a7a96d/00-thumb.jpg",
          :album_page_url => "/album/Event/4c442ae8ff808daa0f000002/photos",
          :id => "event:4c442ae8ff808daa0f000002" 
        },
        :object => {
          :title => "a photo",
          :image_page_url => "/album/Event/4c442ae8ff808daa0f000002/photos/4c4e81c7ff808d20c9000005",
          :id => "image:4c4e81c7ff808d20c9000005",
          :description => "Standing on the stage Club Space WMC 2001",
          :larger_image => "http://destroy_later_blah_blah_blah.s3.amazonaws.com/alltheparties.com//df39e4f8-6944-5d8f-d91f-843620c762f5/P3266699-medium.jpg"
        },
        :verb => "view",
        :title => "Paul Dix viewed a photo in Rip's Photo Album",
        :site => "alltheparties.com",
        :visible => false
      )
      @id = Activity.first.id.to_s if Activity.first.respond_to? :id
    end
    
    it "should return an activity by id: #{@id}" do
      get "/api/#{API_VERSION}/activities/#{@id}"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["actor"]["display_name"].should == "Paul Dix"
    end

    it "should return a activity with an verb" do
      get "/api/#{API_VERSION}/activities/#{@id}"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["verb"].should == "view"
    end

    it "should return site" do
      get "/api/#{API_VERSION}/activities/#{@id}"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["site"].should == "alltheparties.com"
    end

    it "should return proper id" do
      get "/api/#{API_VERSION}/activities/#{@id}"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      attributes["id"].should == @id
    end
    
    it "should return a 404 for a activity that doesn't exist" do
      get "/api/#{API_VERSION}/activities/foo"
      last_response.status.should == 404
    end
  end
  
  describe "POST on /api/#{API_VERSION}/activities" do
    it "should create a activity" do
      post "/api/#{API_VERSION}/activities", {
          :actor => {
            :display_name => "Trotter Cashion",
            :url => "http://www.fcgid.com/person/tcash"
          },
          :object => {},
          :verb => "mark_as_favorite",
          :title => "Paul Dix marked as favorite a photo in Rip's Photo Album",
          :site => "ATP"}.to_json
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)
      get "/api/#{API_VERSION}/activities/#{attributes['id']}"
      attributes = JSON.parse(last_response.body)
      attributes["actor"]["display_name"].should == "Trotter Cashion"
      attributes["actor"]["url"].should == "http://www.fcgid.com/person/tcash"
    end
  end

  describe "DELETE on /api/#{API_VERSION}/activities/:id" do
    before(:each) do
      u = Activity.create(
        :actor => {
          :display_name => "Paul Dix",
          :url => "http://www.fcgid.com/person/paulDiddy"
        },
        :object => {},
        :verb => 'mark_as_favorite',
        :title => "Paul Dix marked as favorite a photo in Rip's Photo Album",
        :site => "ATP",
        :visible => false
      )
      @id = u.id.to_s
    end
    it "should delete a activity" do
      delete "/api/#{API_VERSION}/activities/#{@id}"
      last_response.should be_ok
      get "/api/#{API_VERSION}/activities/#{@id}"
      last_response.status.should == 404
    end
  end
end
