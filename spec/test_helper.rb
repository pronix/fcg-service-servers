dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift dir + '/../lib/fcg-service-servers'
$TESTING = true
ENV["SINATRA_ENV"] = "test"
require 'rubygems'
require 'test/unit'
require "spec/interop/test"
require 'config/boot.rb'

begin
  require 'leftright'
rescue LoadError
end
set :environment, :test
Test::Unit::TestCase.send :include, Rack::Test::Methods



# #
# # make sure we can run mongoDB
# #
# 
# if !system("which mongod")
#   puts '', "** can't find `redis-server` in your path"
#   puts "** try running `sudo rake install`"
#   abort ''
# end
# 
# 
# #
# # start our own redis when the tests start,
# # kill it when they end
# #
# 
# at_exit do
#   next if $!
# 
#   if defined?(MiniTest)
#     exit_code = MiniTest::Unit.new.run(ARGV)
#   else
#     exit_code = Test::Unit::AutoRunner.run
#   end
# 
#   pid = `ps -A -o pid,command | grep [r]edis-test`.split(" ")[0]
#   puts "Killing test redis server..."
#   `rm -f #{dir}/dump.rdb`
#   Process.kill("KILL", pid.to_i)
#   exit exit_code
# end
# 
# puts "Starting redis for testing at localhost:9736..."
# `mongod`


##
# test/spec/mini 3
# http://gist.github.com/25455
# chris@ozmm.org
#
def context(*args, &block)
  return super unless (name = args.first) && block
  require 'test/unit'
  klass = Class.new(defined?(ActiveSupport::TestCase) ? ActiveSupport::TestCase : Test::Unit::TestCase) do
    def self.test(name, &block)
      define_method("test_#{name.gsub(/\W/,'_')}", &block) if block
    end
    def self.xtest(*args) end
    def self.setup(&block) define_method(:setup, &block) end
    def self.teardown(&block) define_method(:teardown, &block) end
  end
  (class << klass; self end).send(:define_method, :name) { name.gsub(/\W/,'_') }
  klass.class_eval &block
end