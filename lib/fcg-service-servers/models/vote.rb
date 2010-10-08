class Vote
  include FCG::Model
  
  field :record,  :type => String
  field :user_id,       :type => String
  field :state,         :type => String
  
  validates_presence_of  :record, :user_id, :state
  validates_inclusion_of :state, :in => %w{ up down}
end