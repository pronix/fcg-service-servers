require 'sinatra' unless defined?(Sinatra)
require File.expand_path("../rest", __FILE__)

module FCG
  module Service
    CONTENT_TYPES = {:js  => 'application/javascript', :msgpack => 'text/html' }
    class Base < Sinatra::Base
      disable :layout
      set :logging, true
      set :run, false
      
      before do
        format = case params[:format]
          when /js(on)?/
            :js
          else
            :msgpack
        end
        content_type CONTENT_TYPES[format], :charset => 'utf-8'
      end
      
      def payload
        @payload ||= begin
          case params[:format]
            when /js(on)?/
              JSON.parse(request.body.read)
            else
              MessagePack.unpack(request.body.read)
          end
        end
      end
      
      def respond_with(result)
        LOGGER.info "result: " + result.inspect
        post_result = case params[:format]
          when /js(on)?/
            result.to_json
          else
            result.to_msgpack
        end
        LOGGER.info "post_result: " + post_result + "\n\n"
        post_result
      end
      
      def error_hash(instance, message)
        errors = instance.errors.inject({}) do |sum,values| 
          k = values.shift
          sum[k] = values.map.andand(&:uniq)
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