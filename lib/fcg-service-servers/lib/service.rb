require 'sinatra' unless defined?(Sinatra)
require File.expand_path("../rest", __FILE__)

module FCG
  module Service
    CONTENT_TYPES = {:html => 'text/html', :css => 'text/css', :js  => 'application/javascript', :default => 'text/plain' }
    class Base < Sinatra::Base
      disable :layout
      set :logging, true
      set :run, false
      
      before do
        format = case request.env['REQUEST_URI']
          when /\.css$/       : :css
          when /\.js(on)?$/   : :js
          when /\.htm(l)?$/   : :html
          else                  :default
        end
        content_type CONTENT_TYPES[format], :charset => 'utf-8'
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



