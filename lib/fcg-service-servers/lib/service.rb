require 'sinatra' unless defined?(Sinatra)
require File.expand_path("../rest", __FILE__)

module FCG
  module Service
    CONTENT_TYPES = {:xml => 'application/xml', :js  => 'application/javascript', :msgpack => 'text/html' }
    class Base < Sinatra::Base
      disable :layout
      set :logging, true
      set :run, false
      
      before do
        format = case params[:format]
          when /js(on)?/
            :js
          when /xml/
            :xml
          else
            :msgpack
        end
        content_type CONTENT_TYPES[format], :charset => 'utf-8'
      end
      
      def respond_with(result)
        case params[:format]
          when /js(on)?/
            result.to_json
          when /xml/
            result.to_xml
          else
            result.to_msgpack
        end
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