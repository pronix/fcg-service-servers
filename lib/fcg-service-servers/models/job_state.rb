class JobState < SimpleRecord::Base
  include FCG::SimpleDB
  has_strings :result, :state, :type, :time_hash
  has_ints :polled
  validates_presence_of :type
end