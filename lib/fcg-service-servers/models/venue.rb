class Venue
  include ActiveModel::Validations
  include MongoMapper::Document
  plugin MongoMapper::Plugins::Paranoid
  
  key :user_id, ObjectId
  key :name, String
  key :address, String
  key :city, String
  key :state, String
  key :zipcode, String
  key :country, String, :default => "US"
  key :time_zone, String
  key :citycode, String
  key :lat, Float
  key :lng, Float
  key :active, Boolean, :default => true
  belongs_to :user
  timestamps!
  
  validates_length_of :name, :within => 1..45
  validates_length_of :address, :within => 3..75
  validates_length_of :city, :within => 2..45,  :if => :not_in_us?
  validates_length_of :state, :within => 2..45, :if => :not_in_us?
  before_create :set_lat_and_lng#, :set_citycode
  before_save :update_city_state_by_zipcode
  
  def full_address
    @full_address = "#{self.address}, #{self.city}, #{self.state}, #{self.zipcode}"
    @full_address << ", #{self.country}" unless in_us?
    @full_address
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
    if in_us?
      self.citycode = Geo.find_citycode_by_zipcode(self.zipcode)
    end
  end
  
  def update_city_state_by_zipcode
    if in_us?
      res = Geo.find_by_country_and_zipcode(self.country, self.zipcode)
      self.city, self.state, self.time_zone = res["CityName"], res["StateAbbr"], res["UTC"] unless res.nil?
    end
  end
end