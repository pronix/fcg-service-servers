class JobState < SimpleRecord::Base
  include FCG::SimpleDB
  has_attributes :job_id, :error_message, :result, :state, :type, :time_hash
  has_ints :polled
end