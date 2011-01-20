class Geo
  include FCG::Model

  field :country, :type => String
  field :zipcode, :type => String
  field :packed, :type => String
  field :msa, :type => String
  field :us_state, :type => String
  field :us_areacode, :type => String
  
  class << self
    def find_by_country_and_zipcode(country, zipcode)
      geo = find(:first, :conditions => {:country => country, :zipcode => zipcode})
      res = JSON.parse(geo.packed) rescue nil
    end

    def geocode_address(address)
      response = Net::HTTP.get_response(URI.parse("http://maps.googleapis.com/maps/api/geocode/json?address=#{Rack::Utils.escape(address)}&sensor=false"))
      json = JSON.decode(response.body)
      self.lat, self.lng = json["results"][0]["geometry"]["location"]["lat"], json["results"][0]["geometry"]["location"]["lng"]
    rescue
      false # For now, fail silently...
    end
  end
end