require 'rubygems'
require "fcg-service-ext"
require "fcg-core-ext"
require 'yajl/json_gem'
require 'hashie'
include Hashie::HashExtensions
include FCG::CoreExt::Utils

dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift dir + 'fcg-service-servers'

Dir[
  File.expand_path("../fcg-service-servers/version.rb", __FILE__),
  File.expand_path("../fcg-service-servers/apps.rb", __FILE__)
].each do |file|
  require file
end