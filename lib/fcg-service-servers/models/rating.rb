class Rating
  include FCG::Model
  
  field :record,        :type => String
  field :user_id,       :type => String
  field :score,         :type => Integer
  
  validates_presence_of  :record, :user_id, :score
  validates_inclusion_of :score, :in => 1..5
  before_save :handle_rating_record
  before_destroy :handle_destroy
  
  
  protected
  def handle_rating_record
    if new_record?
      RatingRecord.add(record, score)
    else
      adjust_rating_record
    end
  end
  
  def adjust_rating_record
    adjusted_score = self.score - self.score_was
    RatingRecord.adjust_score(self.record, adjusted_score)
  end
  
  def handle_destroy
    RatingRecord.add(record, score, :remove)
  end
end