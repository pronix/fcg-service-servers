module FCG
  module SimpleDB
    attr_accessor :model
    module ClassMethods
      def attributes_for_client
        defined_attributes.keys.map(&:to_s).sort.map(&:to_sym)
      end
    end
  
    module InstanceMethods
      def to_hash
        self.serializable_hash.inject({}) do |result, (key, value)|
          case value
          when Date, DateTime, Time
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