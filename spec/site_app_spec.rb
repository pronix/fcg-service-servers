require File.dirname(__FILE__) + '/spec_helper'

describe "Site App" do
  before(:each) do
    Site.delete_all
  end
  
  describe "GET on /sites/:id" do
    before(:each) do
      @site = Fabricate(:site)
      @id = @site.id.to_s
    end
    
    it "should return an site by id: #{@id}" do
      pending do
        get "/sites/#{@id}"
        last_response.should be_ok
        attributes = MessagePack.unpack(last_response.body)
        attributes["id"].should == @id
      end
    end
    
    it "should return a 404 for a site that doesn't exist" do
      pending do
        get "/sites/foo"
        last_response.status.should == 404
        last_response.body.should == "site not found".to_msgpack
      end
    end
  end
  
  describe "POST on /sites" do
    it "should create a site" do
      pending do
        site = {
          
        }
        post "/sites", site.to_msgpack

        last_response.should be_ok
        attributes = MessagePack.unpack(last_response.body)
        get "/sites/#{attributes["id"]}"
        attributes = MessagePack.unpack(last_response.body)
      end
    end
  end

  describe "PUT on /sites/:id" do
    before(:each) do
      @site = Fabricate(:site)
      @id = @site.id.to_s
    end
    
    it "should update a site" do
      pending do
        site = {
          
        }
        put "/sites/#{@id}", site.to_msgpack
        last_response.should be_ok
        attributes = MessagePack.unpack(last_response.body)
      end
    end
  end
  
  describe "DELETE on /sites/:id" do
    before(:each) do
      @site = Fabricate(:site)
      @id = @site.id.to_s
    end
    
    it "should delete a site" do
      delete "/sites/#{@id}"
      last_response.should be_ok
      get "/sites/#{@id}"
      last_response.status.should == 404
    end
  end
end