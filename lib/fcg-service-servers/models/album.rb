class Album
  include FCG::Model
  is_paranoid
  
  field :title,                         :type => String
  field :description,                   :type => String
  field :location,                      :type => String
  field :owner_images,                  :type => Array,   :default => []
  field :owner_image_count,             :type => Integer
  field :user_submitted_images,         :type => Array,   :default => []
  field :user_submitted_image_count,    :type => Integer
  field :total_image_count,             :type => Integer
  field :user_id,                       :type => String
  field :date,                          :type => Date
  
  validates_presence_of :title, :user_id, :date
  validates_length_of :title, :within => 3..100
  validate :date_must_be_passed

  protected
  def date_must_be_passed
    errors.add(:date, "is in the future. We don't take future images.") if date > Date.today
  end
end