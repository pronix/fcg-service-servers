class Album
  include FCG::Model
  # is_paranoid
  
  field :image_type,                    :type => String, :default => "photos" # photos or flyers
  field :record,                        :type => String # event:#{id} or user:#{id}
  field :title,                         :type => String
  field :summary,                       :type => String
  field :location,                      :type => String
  field :owner_images,                  :type => Array,   :default => []
  field :owner_images_order,            :type => String,  :default => "" # ids comma delimited
  field :owner_image_count,             :type => Integer
  field :user_submitted_images,         :type => Array,   :default => []
  field :user_submitted_order,          :type => String,  :default => "" # ids comma delimited
  field :user_submitted_image_count,    :type => Integer
  field :total_image_count,             :type => Integer
  field :user_id,                       :type => String
  field :date,                          :type => Date
  field :comments_allowed,              :type => Boolean
  
  validates_presence_of :title, :user_id, :date, :image_type, :record
  validates_length_of :title, :within => 3..100
  before_save :update_image_count
  # validate :date_must_be_passed
  attr_protected :owner_image_count, :user_submitted_image_count, :total_image_count

  def all_images
    self.owner_images + self.user_submitted_images
  end
  
  protected
  def date_must_be_passed
    errors.add(:date, "is in the future. We don't take future images.") if date > Date.today
  end
  
  def update_image_count
    self.owner_images = [] unless self.owner_images.respond_to? :count
    self.user_submitted_images = [] unless self.user_submitted_images.respond_to? :count
    self.owner_image_count = self.owner_images.count
    self.user_submitted_image_count = self.user_submitted_images.count
    self.total_image_count = self.owner_image_count + self.user_submitted_image_count
  end
end