module FCG
  module SimpleDB
    attr_accessor :model
    module ClassMethods
      def attributes_for_client
        defined_attributes.keys.map(&:to_s).sort.map(&:to_sym)
      end
    end
  
    module InstanceMethods
      def destroy
        self.delete
      end
      
      def to_hash
        self.as_json.inject({}) do |result, (key, value)|
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
      # receiver.send :include, SimpleRecord
      # 
      # model = receiver.to_s.snakecase
      # SimpleRecord::Base.set_table_name model.to_sym
    end
  end
end

# fixes add_on_blank error
module SimpleRecord
  class SimpleRecord_errors
    alias :add_on_blank :add
  end
end