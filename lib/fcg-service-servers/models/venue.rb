require 'net/http'
require 'rexml/document'
require "rubygems"
require "geokit"

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
  before_create :set_lat_and_lng, :set_default
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
  
  def save
    old_venues = []

    unless self.lat.nil? || self.lng.nil?
      old_venues = Venue.find(:all, :conditions => {:lat => self.lat, :lng => self.lng})
    end

    if old_venues.length == 0
      old_venues = Venue.find(:all, :conditions => {:country => self.country,
                               :zipcode => self.zipcode,
                               :city => self.city,
                               :state => self.state,
                               :address => self.address,
                               :active => true}, :sort => [["created_at", "ascending"]])
    end

    unless old_venues.length == 0
      oldest_venue = nil

      old_venues.each do |venue|
        if is_similar?(venue.name, self.name)
          if self.created_at.nil? || venue.created_at < self.created_at && venue.id != self.id
            oldest_venue = venue
          end
        end
      end

      if self.new_record?
        unless oldest_venue.nil?
          self.id = oldest_venue.id
          self.name = oldest_venue.name
          self.user_id = oldest_venue.user_id
        else
          super
        end
      elsif old_venues.length > 1
        unless oldest_venue.nil?
          events = Event.find(:all, :conditions => {:venue => self.to_hash})

          events.each do |event|
            event.venue = oldest_venue.to_hash
            event.save
          end

          parties = Party.find(:all, :conditions => {:venue => self.to_hash})

          parties.each do |party|
            party.venue = oldest_venue.to_hash
            party.save
          end

          albums = Album.find(:all, :conditions => {:venue => self.to_hash})

          albums.each do |album|
            album.venue = oldest_venue.to_hash
            album.save
          end

          users = User.find(:all, :conditions => {:venue => self.to_hash})

          users.each do |user|
            user.venue = oldest_venue.to_hash
            user.save
          end

          self.id = oldest_venue.id
          self.name = oldest_venue.name
          self.user_id = oldest_venue.user_id
        else
          super
        end
      end
    else
      super
    end
  end

  protected
  def set_lat_and_lng
    #return true
    if in_us?
      res = Geokit::Geocoders::GoogleGeocoder.geocode(self.full_address) rescue nil

      unless res.nil?
        self.lat = res.lat
        self.lng = res.lng
      else
        self.lat, self.lng = nil, nil
      end
    end
  end

  def set_citycode
    self.citycode = Geo.find_citycode_by_zipcode(self.zipcode) if in_us?
  end
  
  def update_city_state_by_zipcode
    if in_us?
      zipcode = self.zipcode.split(/-/).first
      res = Geo.find_by_country_and_zipcode(self.country, zipcode)
      self.city, self.state, self.time_zone = res["CityName"], res["StateAbbr"], res["UTC"] unless res.nil?
    end
  end

  def is_similar?(text1, text2)
    !text1.downcase.index(text2.downcase).nil? || !text2.downcase.index(text1.downcase).nil?
  end

  def set_default
    if self.active.nil?
      self.active = true
    end

    if self.country.nil?
      self.country = "US"
    end
  end
end