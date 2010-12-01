class JobState < SimpleRecord::Base
  include FCG::SimpleDB
  has_attributes :job_id, :error_message, :result, :state, :type, :time_hash
  has_ints :polled
  validates_presence_of :job_id, :type
  
  class << self
  end
  
  def errors_exist?
    !JSON.parse(self.error_message).empty?
  end
end