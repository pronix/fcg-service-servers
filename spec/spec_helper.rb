$TESTING = true
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift dir + '/../lib/fcg-service-servers'
ENV['SINATRA_ENV'] = 'test'
ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), '..', 'lib', 'fcg-service-servers')
require 'rspec'
require 'test/unit'
require 'rack/test'
require 'mocha'
require 'fabrication'
require 'database_cleaner'
require 'ffaker'
require 'timecop'
require 'ruby-debug'

# load fabricators
Dir[File.expand_path(File.join(File.dirname(__FILE__),'fabricators','**','*.rb'))].each{ |file| require file }

set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

def app
  @app ||= FCG::Service::Server
end

def new_id
  rand(23602195835208247086376026138).to_s(16)
end

def text_as_html(text)
  RDiscount.new(text, :autolink).to_html
end

RSpec.configure do |config|
  config.mock_with :rspec
  
  config.include Rack::Test::Methods
  
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = 'mongoid'
  end
  
  config.before(:each) do
    DatabaseCleaner.clean
  end
end
