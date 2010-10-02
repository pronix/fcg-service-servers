require 'sinatra' unless defined?(Sinatra)
module FCG
  module Service
    class Base < Sinatra::Base
      disable :layout
      set :logging, :true
      
      before do
        content_type :json
      end
      
      def error_hash(instance, message)
        errors = instance.errors.inject({}) do |sum,values| 
          k = values.shift
          sum[k] = values.map(&:uniq)
          sum
        end
        {
          :message => message,
          :errors => errors
        }
      end
    end
  end
end