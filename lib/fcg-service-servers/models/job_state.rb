class JobState < SimpleRecord::Base
  include FCG::SimpleDB
  has_strings :job_id, :error_message, :result, :state, :type, :time_hash
  has_ints :polled
  validates_presence_of :job_id, :type
  
end