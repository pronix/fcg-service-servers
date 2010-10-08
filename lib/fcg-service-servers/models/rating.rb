class Rating
  include FCG::Model
  
  field :record,  :type => String
  field :user_id,       :type => String
  field :score,         :type => Integer
  
  validates_presence_of     :record, :user_id, :score
  validates_inclusion_of :score, :in => 1..5
end