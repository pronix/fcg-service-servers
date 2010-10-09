class RatingRecord
  include FCG::Model
  
  field :record,            :type => String
  field :hashed_record,     :type => String
  field :rating_count,      :type => Integer, :default => 0
  field :score_total,       :type => Float,   :default => 0.0
  field :score_average,     :type => Float,   :default => 0.0
  key   :hashed_record
  
  before_create :create_record_id_hashed
  
  class << self
    def find_with_hashed_record(record)
      find(Digest::SHA1.hexdigest(record))
    end
    
    def add(record, score, action = :insert)
      if result = find_with_hashed_record(record)
        result.update_score!(action, score)
      else
        result = create(:record => record, :rating_count => 1, :score_total => score, :score_average => score.to_f)
      end
    end
    
    def adjust_score(record, score)
      if result = find_with_hashed_record(record)
        result.score_total += score
        result.score_average = result.score_total / result.score_total
        result.save
      end
    end
  end
  
  
  
  def update_score!(action, score)
    case action
    when :insert
      self.rating_count += 1
      self.score_total += score
    when :remove
      self.rating_count -= 1
      self.score_total -= score
    else
      raise "Invalid action"
    end
    self.score_average = (self.rating_count == 0) ? 0.0 : self.score_total / self.rating_count
    self.save
  end
  
  protected
  def create_record_id_hashed
    self.hashed_record = Digest::SHA1.hexdigest(record)
  end
end