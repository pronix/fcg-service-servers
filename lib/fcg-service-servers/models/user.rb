class User
  include ActiveModel::Validations
  include MongoMapper::Document

  plugin MongoMapper::Plugins::Paranoid
  plugin UserHashPlugin
  plugin TokenPlugin
  plugin SocialPlugin
  plugin ImagePlugin
  
  scope :existing, where(:deleted_at => nil )
  scope :by_email, lambda{|email| where(:email => email.downcase) }
  scope :by_username, lambda{|username| where(:username => username.downcase) }
  
  image_keys :photo
  key :username, String
  key :email, String
  key :crypted_password, String
  key :salt, String
  key :date_of_birth, Time
  key :last_visited_at, Time
  key :posted_party_at, Time
  
  # profiles
  key :profile_image, String
  key :sex, String
  key :web, String
  key :bio, String
  timestamps!
  
  attr_accessor :password
  
  validates_with UserValidator
  validates_length_of :username, :within => 3..16
  validates_length_of :email, :within => 6..100
  validates_format_of :email, :with => FCG::Validation::REGEX[:email]
  validates_format_of :username, :with => FCG::Validation::REGEX[:username]
  
  before_save   :encrypt_password, :set_city_state_using_us_zipcode
  before_create :setup
  
  class << self
    def encrypt(password, salt)
      Digest::SHA1.hexdigest("-9{-}#{salt}-*-#{password}-215-")
    end
    
    def authenticate(email_or_username, password, encrypted=true)
      case email_or_username
      when FCG::Validation::REGEX[:email]
        user = where(:email => email_or_username).first
      else
        user = where(:username => email_or_username).first
      end
      user && user.authenticated?(password) && user.flags[:enabled] ? user : nil
    end
  end
  
  def display_name
    full_name || username
  end
  
  def username=(val)
    if new_record?
      write_attribute(:username, val.downcase)
    end
  end
  
  def email=(val)
    write_attribute(:email, val.downcase)
  end
  
  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def password_required?
    new_record? || crypted_password.blank? || !password.blank?
  end

  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{username}-#{Guid.new}-email--") if new_record?
    self.crypted_password = encrypt(password)
  end
  
  def confirm!
    self.flags[:confirmed] = true
    save!
  end
  
  def logged_in_successfully!
    self.token_id = nil
    self.token_expire_at = nil
    self.last_visited_at = Time.now.utc
    save!
  end
  
  def user_info
    {
      :id             => self.id,
      :username       => self.username,
      :location       => self.location,
      :display_name => self.display_name,
      :profile_image  => self.profile_image
    }
  end
  
  def promoter?
    !self.posted_party_at.nil? and self.posted_party_at != ""
  end

  def photographer?
    !self.uploaded_photos_at.nil? and self.uploaded_photos_at != ""
  end
  
  def uploadable_by_user?(user)
    return true if user.id == self.id
  end
  
  def remove_key(key)
    self.class.collection.update(
      {"_id" => self.id }, 
      { "$unset" => { key => 1 } }
    )
  end
  
  protected
  def setup
    self.location[:country] = "US"
    self.token_id = "#{Time.now.utc.to_i}-#{Guid.new}"
    self.flags = {
      :enabled => true,
      :confirmed => false,
      :keep_profile_private => false
    }
  end
  
  def set_city_state_using_us_zipcode
    return true
    # this should be done asynchronously
    res = JSON.parse(DB[:geo]["#{self.location[:country]}-zipcode:#{self.location[:zipcode]}".downcase]) rescue nil
    self.location[:city], self.location[:state], self.location[:time_zone] = res["CityName"], res["StateAbbr"], res["UTC"] unless res.nil?
  end
end