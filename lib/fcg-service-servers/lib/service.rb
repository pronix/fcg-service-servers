require 'sinatra' unless defined?(Sinatra)
require File.expand_path("../rest", __FILE__)

module FCG
  module Service
    CONTENT_TYPES = {:html => 'text/html', :css => 'text/css', :js  => 'application/javascript'}
    class Base < Sinatra::Base
      disable :layout
      set :logging, :true
      
      before do
       request_uri = case request.env['REQUEST_URI']
         when /\.css$/ : :css
         when /\.js$/  : :js
         else          :html
       end
       content_type CONTENT_TYPES[request_uri], :charset => 'utf-8'
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



