class Bookmark
  include FCG::Model
  
  scope :by_user, lambda { |user_id| where(:user_id => user_id) }
  scope :by_type, lambda { |type| where("extra.type" => type) }
  scope :by_citycode, lambda { |city| where("extra.citycode" => city) }
  
  field :user_id,       :type => String
  field :title,         :type => String
  field :path,          :type => String
  field :record,  :type => String
  field :site,          :type => String
  field :extra,         :type => Hash,    :default => {}
  
  validates_presence_of :user_id, :site, :path, :record
end