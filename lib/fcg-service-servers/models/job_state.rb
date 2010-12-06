class JobState < SimpleRecord::Base
  include FCG::SimpleDB
  has_strings :result, :error_message, :site, :state, :time_hash
  has_ints :polled
  # NOTE: validate on the FCG service client level
  # validates_presence_of :site, :state
  
  def polled!
    self.polled += 1
    self.save
  end
end