class Feed
  include FCG::Model
  
  field :title,         :type => String
  field :user_id,       :type => String
  field :site,          :type => String
  field :record,  :type => String
  
  validates_presence_of :title, :user_id, :site, :record
end