class Follower
  include FCG::Model
  
  field :leader_id,     :type => String
  field :follower_id,   :type => String
  field :approved,      :type => Boolean, :default => true
  
  key :follower_id, :leader_id
  
  validates_presence_of :leader_id, :follower_id
end