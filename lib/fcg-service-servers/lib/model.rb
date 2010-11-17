module FCG
  module Model
    module ClassMethods
      def is_paranoid
        self.send :include, Mongoid::Paranoia
      end
    
      def is_versioned(versions=5)
        self.send :include, Mongoid::Versioning
        max_versions versions
      end
    
      def has_transitions
        self.send :include, Transitions
      end
    end
  
    module InstanceMethods
      def to_hash
        self.serializable_hash.reject{|key, value| key.to_s == "versions" }.inject({}) do |result, (key, value)|
          key, value = "id", value.to_s if key.to_s == "_id"
          case value
          when Date, DateTime, Time, BSON::ObjectId
            value = value.to_s
          end
          result[key] = value
          result
        end
      end
    
      def to_msgpack(*args)
        self.to_hash.to_msgpack(*args)
      end
    end
  
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
      receiver.send :include, Mongoid::Document
      receiver.send :include, Mongoid::Timestamps
      receiver.attr_protected :_id
    end
  end
end