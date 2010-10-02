class PartyValidator < ActiveModel::Validator
  def validate(record)
    record.description = Sanitize.clean(record.description)
    validate_user(record)
    validate_venue(record)
    validate_times(record)
  end
  
  private
  def validate_times(record)
    unless record.next_date.nil?
      unless record.start_time.nil? and record.end_time.nil?
        record.length_in_hours = record.get_length_in_hours
      else
        record.errors[:start_time] << "is not valid." if record.start_time.nil?
        record.errors.add[:end_time] << "is not valid." if record.end_time.nil?
      end
    else
      record.errors[:next_date] << "is not valid."
    end
  end
  
  def validate_user(record)    
    if !record.user_id.nil? 
      unless user = User.find(record.user_id)
        record.errors[:user] << "can't be found"
      end
    else
      record.errors[:user] << "can't be blank"
    end
  end
  
  def validate_venue(record)
    if !record.venue_id.nil?
      venue = Venue.find(record.venue_id) rescue nil
      if venue.nil?
        record.errors[:venue] << "can't be found"
      end
    else
      record.errors[:venue] << "can't be blank"
    end
  end
end