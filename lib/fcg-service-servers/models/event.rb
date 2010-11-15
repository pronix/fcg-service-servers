class Event
  include FCG::Model
  # is_paranoid
  # is_versioned
  include ImagePlugin
  
  image_keys :photo, :flyer
  
  scope :active, where(:active => true)
  scope :by_range, lambda {|date_range| where(:start_time_utc.gt => date_range.first, :start_time_utc.lte => date_range.last) }
  scope :future, lambda {|time| where(:start_time_utc.gt => time) }
  scope :past,   lambda {|time| where(:start_time_utc.lte => time) }
  scope :recent, lambda { where(:date.gt => Time.now.utc).sort(:date) }
  scope :by_citycode, lambda { |city| where(:"venue.citycode" => city) }
  
  field :user_id, :type => String
  field :party_id, :type => String
  field :venue, :type => Hash
  
  field :title, :type => String
  field :description, :type => String
  field :music, :type => String
  field :host, :type => String
  field :dj, :type => String
  field :start_time, :type => String
  field :end_time, :type => String
  
  field :length_in_hours, :type => Integer
    
  field :comments_allowed, :type => Boolean, :default => true
  field :active, :type => Boolean, :default => true
  
  field :date, :type => Date
  field :start_time_utc, :type => Time
  field :end_time_utc, :type => Time
  field :posted_to_twitter_at, :type => Date
  
  validates_presence_of :user_id, :party_id, :venue, :date
  validates_format_of :start_time, :with => /^(0?[1-9]|1[0-2]):(00|15|30|45)(a|p)m$/i
  validates_format_of :end_time, :with => /^(0?[1-9]|1[0-2]):(00|15|30|45)(a|p)m$/i
  # after_create :handle_after_create
  
  class << self
    def create_based_on_party(party)
      create(:party => party)
    end
    
    def upcoming_the_next_7_days
      now = 6.hours.ago(Time.now.utc)
      date_range = now.beginning_of_day..7.days.since(now).end_of_day
      by_range(date_range).active
    end
  end
  
  def photo_album_title
    txt = date.short_date + ": #{title_and_venue_name}"
    txt << " (#{photo_album[:title]})" if photo_album[:title]
    txt
  end
  
  def cover_image
    Image.find(photos_sorted.first) unless photos.empty?
  end
  
  def update_from_party(party, new_date)
    self.party  = party
    self.date = new_date
    set_utc(party.date, party.start_time, party.length_in_hours)
  end
  
  def parse_time(date_time)
    Time.parse date_time.to_s
  end
  
  def set_utc(date, start_time, hrs)
    raw_start_time = parse_time( date.to_s + " " + start_time )
    end_date_time = hrs.to_i.hours.since(raw_start_time)
    write_attribute(:start_time_utc, raw_start_time.local_to_utc( time_zone ))
    raw_end_time_utc = end_date_time.local_to_utc( time_zone )
    write_attribute(:end_time_utc, raw_end_time_utc)
  end
  
  def venue_name
    venue[:name]
  end
  
  def date=(val)
    write_attribute(:date, Date.parse(val))
  end
  
  # def venue=(val)
  #   write_attribute(:venue_id, val.id)
  #   write_attribute(:venue_name, val.name)
  #   write_attribute(:lat, val.lat) unless lat.nil?
  #   write_attribute(:lng, val.lng) unless lng.nil?
  #   write_attribute(:citycode, val.citycode) unless citycode?
  # end
  
  def party=(val)
    write_attribute(:party_id, val.id)
    write_attribute(:title, val.title)
    write_attribute(:venue, val.venue)
    write_attribute(:start_time, val.start_time)
    write_attribute(:end_time, val.end_time)
    write_attribute(:user_id, val.user_id)
    write_attribute(:date, val.next_date)
    set_utc(val.next_date, val.start_time, val.length_in_hours)
  end
  
  def full_address
    venue[:full_address]
  end
  
  def time_zone
    venue[:time_zone]
  end

  def title_and_venue_name
    "#{title} at #{venue_name}"
  end
  
  def album_title(album_type=nil)
    txt = "#{date.to_s(:slash)}: #{title} at #{venue_name}"
    album_type = self.image_method(album_type.to_sym) rescue nil
    txt << "(" + album_type["title"] + ")" unless album_type.nil?
    txt
  end
  
  # def set_to_param
  #   write_attribute :to_param, %Q{#{self.id}-#{[self.title, self.venue.name, self.venue.city, self.venue.state].join(' ').gsub(/[^a-z0-9]+/i, '_')}}
  # end
  
  def past?
    self.end_time_utc < Time.now.utc
  end
  
  def uploadable_by_user?(*args)
    self.party.uploadable_by_user?(*args)
  end
end