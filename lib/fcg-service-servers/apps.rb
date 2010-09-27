require File.dirname(__FILE__) + '/config/boot.rb'
require 'rack/mount'

FCG::Service::Server = Rack::Mount::RouteSet.new do |set|
  # add_route takes a rack application and conditions to match with
  #
  # valid conditions methods are any method on Rack::Request
  # the values to match against may be strings or regexps
  #
  # See Rack::Mount::RouteSet#add_route for more options.
  # set.add_route FooApp, { :request_method => 'GET', :path_info => %r{^/foo$} }, {}, :foo
  
  # Find all FCG::Service constants that end in App and add them to routes
  FCG::Service.constants.select{|f| f[-3..-1] == "App" }.each do |app|
    set.add_route FCG::Service.const_get(app)
  end
end