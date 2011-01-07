class Activity < SimpleRecord::Base
  include FCG::SimpleDB
  
  # [actor] [verb] [object] [target]
  has_strings :user_id
  has_strings :verb
  has_strings :object_type, :object_id
  has_strings :target
  has_strings :title
  has_strings :page
  has_strings :site
  has_strings :city
  has_strings :extra
  has_booleans :was_summarized
end