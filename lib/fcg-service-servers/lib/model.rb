module FCG::Model
  module ClassMethods
    def is_paranoid
      self.send :include, Mongoid::Paranoia
    end
    
    def is_versioned(versions=5)
      self.send :include, Mongoid::Versioning
      max_versions versions
    end
    
    def has_state
      self.send :include, Transitions
    end
  end
  
  module InstanceMethods
    def to_hash
      self.attributes.inject({}) do |result, (key, value)|
        key, value = "id", value.to_s if key.to_s == "_id"
        result[key] = value
        result
      end
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
    receiver.send :include, Mongoid::Document
    receiver.send :include, Mongoid::Timestamps
  end
end