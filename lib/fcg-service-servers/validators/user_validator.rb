class UserValidator < ActiveModel::Validator
  def validate(record)
    if record.new_record?
      check_if_username_and_email_available(record)
      check_for_bad_username(record)
    end
  end

  private
  def check_if_username_and_email_available(record)
    [:username, :email].each do |col|
      record.errors.add(col, "is taken. Please try another.") if exists?(record, col)
    end
  end
  
  def check_for_bad_username(record)
    record.errors.add :username, 'is a bad nickname... Please choose another' if FCG::Validation::BAD_USERNAMES.include?(record.username)
  end
  
  def exists?(record, column) # return true if record is unique and doesn't belong to current record
    value = record.send(column)
    res = case column
      when :username
        user = User.find_by_username(value)
        if user
          user == record ? false : true
        end
      when :email
        user = User.find_by_email(value)
        if user
          user == record ? false : true
        end 
    end
    return false if res.nil?
    res
  end
end