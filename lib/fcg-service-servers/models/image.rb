class Image
  include FCG::Model
  is_paranoid
  
  field :job_id,    :type => String
  field :caption,   :type => String
  field :state,     :type => String, :default => "new"
  field :types,     :type => Array
  field :url,       :type => Hash
  field :size,      :type => Hash
  field :user_id,   :type => String
  
  validates_presence_of :user_id, :types, :state
  
  class << self
    def add_to_objekt(val)
      img = self.by_job_id(val["id"]).first
      if img.nil?
        img = new(
          :job_id => val["id"],
          :user_id => val["user_id"],
          :types => FCG_CONFIG.image[val["objekt_type"].downcase.to_sym]
        )
      end
      begin
        img.url["original"] = val["original_url"] if val.has_key?("original_url")
        img.url[val['suffix']] = val["url"]
        img.size[val['suffix']] = val["size"]
        if img.check_if_completed?
          img.state = "completed"
          objekt = find_objekt(val["type"], val["objekt_id"])
          add_image_to_objekt(objekt, val["type"]).call(img)
        end
        img.save
      rescue Exception => e
        LOGGER.debug img.errors.inspect
        LOGGER.debug "#{Exception} => #{e}"
      end
    end
    
    def add_image_to_objekt(objekt, type)
      lambda do |img|
        case type
        when "Event", "User"
          objekt.add_photo!(img)
        when "Flyer"
          objekt.add_flyer!(img)
        end
      end
    end
    
    def find_objekt(type, objekt_id)
      case type
      when "Event"
        Event.find(objekt_id)
      when "User"
        User.find(objekt_id)
      when "Flyer"
        Event.find(objekt_id)
      end
    end
    
    def from_job_hash(val)
      imgs = case val["type"]
      when "Event", "User"
        objekt = val["type"].constantize.find(val["objekt_id"])
        objekt.photos
      when "Flyer"
        objekt = Event.find(val["objekt_id"])
        objekt.flyers
      end
      imgs.detect{|img| img.job_id == val["job_id"] }
    end
  end
  
  def sizes
    types.map{|t| FCG_CONFIG[:image][:sizes][t] }
  end
  
  def check_if_completed?
    return true if self.state == "completed"
    self.types.all?{|t| self.url[t] }
  end
  
  protected
  def handle_after_create
    return true
    # should be handled asynchronosly
    case album.image_type
    when "self"
      obj = album.objekt
      case objekt_type
      when "User"
        obj.set_as_profile_image!(self)
      when "Event"
        obj.photos << self
        unless obj.has_images
          obj.has_images = true
        end
        obj.save
      end
    when "flyer"
      event = objekt
      event.set_as_flyer_image!(self)
    end
  end
  
end