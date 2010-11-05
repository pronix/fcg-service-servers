class Venue
  include FCG::Model
  # is_paranoid
  
  field :user_id, :type => String
  field :name, :type => String
  field :address, :type => String
  field :city, :type => String
  field :state, :type => String
  field :zipcode, :type => String
  field :country, :type => String, :default => "US"
  field :time_zone, :type => String
  field :citycode, :type => String
  field :lat, :type => Float
  field :lng, :type => Float
  field :active, :type => Boolean, :default => true
  
  validates_length_of :name, :within => 1..45
  validates_length_of :address, :within => 3..75
  validates_length_of :city, :within => 2..45,  :if => :not_in_us?
  validates_length_of :state, :within => 2..45, :if => :not_in_us?
  before_create :set_lat_and_lng
  before_save :update_city_state_by_zipcode #:set_citycode
  
  def full_address
    res = "#{self.address}, #{self.city}, #{self.state}, #{self.zipcode}"
    res << ", #{self.country}" unless in_us?
    res
  end
  
  def to_param
    "#{id}-#{[name, address, city, state].join(' ').gsub(/[^a-z0-9]+/i, '_')}"
  end

  def not_in_us?
    !self.country == "US"
  end
    
  def in_us?
    self.country == "US"
  end
  
  protected
  def set_lat_and_lng
    return true
    if in_us?
      res = Geokit::Geocoders::GoogleGeocoder.geocode(self.full_address) rescue [nil,nil]
      self.lat, self.lng = res.lat, res.lng
    end
  end
  
  def set_citycode
    self.citycode = Geo.find_citycode_by_zipcode(self.zipcode) if in_us?
  end
  
  def update_city_state_by_zipcode
    if in_us?
      zip = self.zipcode.split(/-/).first
      res = Geo.find_by_country_and_zipcode(self.country, self.zipcode)
      self.city, self.state, self.time_zone = res["CityName"], res["StateAbbr"], res["UTC"] unless res.nil?
    end
  end
end