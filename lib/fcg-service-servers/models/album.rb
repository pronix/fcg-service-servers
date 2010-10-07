class Album
  include FCG::Model
  is_paranoid
  
  field :title,                         :type => String
  field :description,                   :type => String
  field :owner_images,                  :type => Array,   :default => []
  field :owner_image_count,             :type => Integer
  field :user_submitted_images,         :type => Array,   :default => []
  field :user_submitted_image_count,    :type => Integer
  field :total_image_count,             :type => Integer
  field :user_id,                       :type => String # aka user_id
  validates_precense_of :title, :user_id
  
end