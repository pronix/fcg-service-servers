class Rating
  include FCG::Model
  
  field :model_and_id,  :type => String
  field :user_id,       :type => String
  field :score,         :type => Integer
  
  validates_presence_of     :model_and_id, :user_id, :score
  validates_inclusion_of :score, :in => 1..5
end