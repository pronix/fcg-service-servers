require "bundler"

env_arg = ARGV.index("-e")
FCG_ENV = (env_arg || ENV["SINATRA_ENV"] || "development").to_sym 

Bundler.setup
Bundler.require(:default, FCG_ENV)

# Redisk.redis = 'myhost:myport'
# logger = Logger.new(Redisk::IO.new("#{FCG_ENV}.log"))

configure do
  FCG_CONFIG = %w(app amqp redis).inject(Hashie::Mash.new) do |result, file|
    raw_config = File.read(File.expand_path("../settings/#{file}.yml", __FILE__))
    result[file.to_sym]= Hashie::Mash.new(YAML.load(raw_config)[FCG_ENV.to_s])
    result
  end
  
  # Redis Client
  REDIS = Redis.new :db => FCG_CONFIG.redis.db, :host => FCG_CONFIG.redis.host, :port => FCG_CONFIG.redis.port, :timeout => 2
  
  # Bunny Client
  ASYNC_CLIENT = Bunny.new(:host => FCG_CONFIG.amqp.host, :user => FCG_CONFIG.amqp.user, :pass => FCG_CONFIG.amqp.pass)
  ASYNC_CLIENT.start

  API_VERSION = FCG_CONFIG.app.version

  MongoMapper.connection = Mongo::Connection.new(FCG_CONFIG.app.mongodb_host, nil, :logger => nil)
  MongoMapper.database = "fcg_#{FCG_ENV}"
  
  # Load all necessary files
  Dir[
    File.expand_path("../../lib/service.rb", __FILE__),
    File.expand_path("../../validators/*.rb", __FILE__),
    File.expand_path("../../models/*.rb", __FILE__),
    File.expand_path("../../apps/*.rb", __FILE__),
    File.expand_path("../../db/*.rb", __FILE__)
  ].each do |file|
    require file
  end
end