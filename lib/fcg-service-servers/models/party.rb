class Party
  include FCG::Model
  is_paranoid
  RECUR = %w{ once weekly }
  
  scope :by_user, lambda { |userid| where(:user_id => userid) }

  field :user_id, :type => String
  field :venue, :type => Hash
  field :events, :type => Hash, :default => {}
  field :url, :type => String
  field :title, :type => String
  field :host, :type => String
  field :dj, :type => String
  field :music, :type => String
  field :description, :type => String
  field :rsvp_email, :type => String
  field :photographer_list, :type => Array
  field :start_time, :type => String, :default => "11:00PM"
  field :end_time, :type => String, :default => "4:00AM"
  
  field :door_charge_in_cents, :type => Integer
  field :guestlist_in_cents, :type => Integer
  field :length_in_hours, :type => Float
  field :next_date, :type => Date
  field :end_date, :type => Date
  field :comments_allowed, :type => Boolean, :default => true
  field :premium, :type => Boolean, :default => false
  field :active, :type => Boolean, :default => true
  field :deleted, :type => Boolean, :default => false
  field :hide_guestlist, :type => Boolean, :default => false
  field :private, :type => Boolean, :default => false
  field :post_updates_to_twitter, :type => Boolean, :default => false
  
  # frequency parameters
  field :recur, :type => String
  field :pictures_left, :type => Integer, :default => 0
  field :days_left, :type => Integer, :default => 7
  field :days_free, :type => Integer, :default => 7
  field :days_paid, :type => Integer, :default => 0
  
  attr_accessor :venue_name, :weekly, :old_event_id
  
  validates_with PartyValidator
  validates_presence_of :title, :music, :description, :venue, :user_id, :next_date
  validates_format_of :start_time, :with => /^(0?[1-9]|1[0-2]):(00|15|30|45)(a|p)m$/i
  validates_format_of :end_time, :with => /^(0?[1-9]|1[0-2]):(00|15|30|45)(a|p)m$/i
  validates_length_of :title,   :within => 3..64
  validates_length_of :description,   :within => 3..5000
  before_create :handle_before_create
  before_update :handle_before_update
  
  def weekly
    recur == "weekly"
  end
  
  def weekly=(val)
    if val.to_i == 1
      self.recur = "weekly"
    else
      self.recur = "once"
    end
  end
  
  def venue_name
    venue[:name]
  end
  
  def next_date=(val)
    write_attribute(:next_date, Date.parse(val))
  end
  
  def current_event
    return nil if current_event_id.nil?
    Event.find(current_event_id)
  end
  
  def current_event_id
    events["#{next_date}"]
  end
  
  def create_current_event
    event = Event.create_based_on_party(self) if current_event.nil? 
  end
  
  # def to_param
  #   %Q{#{id}-#{[title, venue.name, venue.city, venue.state].join(' ').gsub(/[^a-z0-9]+/i, '_')}}
  # end
  
  def get_length_in_hours
    start_t = Time.parse("#{self.next_date} #{self.start_time}") 
    end_t = Time.parse("#{self.next_date} #{self.end_time}")
    case start_t <=> end_t
      when 1
        (24 - (start_t - end_t) / 3600 ).to_f
      when -1
        ((start_t - end_t) / 3600 ).to_f.abs
      when 0
        24
    end
  end
  
  def events_as_id_hashes
    events.inject({}) do |sum, (key, value)|
      sum[key.to_s] = value.to_s
      sum
    end
  end
  
  def uploadable_by_user?(user)
    return true if user.id == self.user_id or photographer_list.include?("email:#{user.email}") or photographer_list.include?("username:#{user.username}")
    false
  end
  
  protected
  def handle_before_create
    self.events[self.next_date.to_s] = begin
      ev = Event.create_based_on_party(self)
      raise "Bad Event (\nevent: #{ev.errors.inspect}\nparty: #{self.errors.inspect})" unless ev.valid?
      ev.id.to_s
    end
  end
  
  def handle_before_update
    if self.active and self.current_event and self.current_event.date == self.next_date
      ev = self.current_event
      ev.party = self
      ev.save
    end
    if self.next_date_changed? and self.current_event and old_event = Event.find(self.events[self.next_date_was.to_s])
      old_event.active = false
      old_event.save
    end
  end
end