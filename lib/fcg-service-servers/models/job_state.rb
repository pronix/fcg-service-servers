class JobState < SimpleRecord::Base
  include FCG::SimpleDB
  has_strings :result, :error_message, :site, :state, :time_hash
  has_ints :polled
  validates_presence_of :site, :state
end