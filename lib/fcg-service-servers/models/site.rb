class Site
  include FCG::Model

  field :url, :type => String
  field :packed, :type => String
  field :cities, :type => Hash
  field :active_cities_sorted, :type => String
  
  class << self
    def find_by_country_and_zipcode(country, zipcode)
      key = "#{country}-zipcode:#{zipcode}".downcase
      @res = JSON.parse(GEO_REDIS[key]) rescue nil
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