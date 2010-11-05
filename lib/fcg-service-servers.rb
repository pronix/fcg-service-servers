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

# /Users/onyekwelu/.rvm/gems/ruby-1.8.7-p249/bin:
# /Users/onyekwelu/.rvm/gems/ruby-1.8.7-p249@global/bin:
# /Users/onyekwelu/.rvm/rubies/ruby-1.8.7-p249/bin:
# /Users/onyekwelu/.rvm/bin:
# /usr/local/sbin:
# /Users/onyekwelu/db/mongodb/bin:
# /System/Library/Frameworks/JavaVM.framework/Versions/1.6/Home:
# ~/bin:~/rds/bin:~/ec2/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin
