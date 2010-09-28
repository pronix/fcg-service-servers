class Geo
  class << self
    def find_by_country_and_zipcode(country, zipcode)
      @res ||= JSON.parse(REDIS["#{country}-zipcode:#{zipcode}".downcase]) rescue nil
    end
    
    # def find_citycode_by_zipcode(zipcode)
    #   CITIES.keys.detect do |city|
    #     DB[:geo].sismember "site:#{FCG_CONFIG[:app][:base_domain]}:city:#{city}:zipcodes", zipcode
    #   end
    # end
  end
end