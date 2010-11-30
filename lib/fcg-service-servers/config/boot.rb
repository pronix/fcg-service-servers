require "bundler"
env_arg = ARGV.index("-e")
FCG_ENV = (env_arg || ENV["SINATRA_ENV"] || "development").to_sym unless defined? FCG_ENV
begin
  Bundler.setup
  Bundler.require(:default, FCG_ENV)

  configure do
    FCG_CONFIG = %w(app amqp redis mongodb image).inject(Hashie::Mash.new) do |result, file|
      raw_config = File.read(File.expand_path("../settings/#{file}.yml", __FILE__))
      result[file.to_sym]= Hashie::Mash.new(YAML.load(raw_config)[FCG_ENV.to_s])
      result
    end unless defined? FCG_CONFIG
  
    API_VERSION = FCG_CONFIG.app.version unless defined? API_VERSION
  
    # Redis Client
    REDIS       = Redis.new :db => FCG_CONFIG.redis.db, :host => FCG_CONFIG.redis.host, :port => FCG_CONFIG.redis.port, :timeout => 10 
    GEO_REDIS   = Redis::Namespace.new(:geo,  :redis => REDIS)
    SITE_REDIS  = Redis::Namespace.new(:site, :redis => REDIS)
  
    LOGGER = Logger.new(File.expand_path("../../../../log/#{FCG_ENV}.log", __FILE__))
    LOGGER.level  = Logger::INFO
  
    # Bunny Client
    begin
      unless FCG_ENV == "test"
        ASYNC_CLIENT = Bunny.new(:host => FCG_CONFIG.amqp.host, :user => FCG_CONFIG.amqp.user, :pass => FCG_CONFIG.amqp.pass)
        ASYNC_CLIENT.start
      end
    rescue Qrack::ConnectionTimeout
      puts "ASYNC_CLIENT is timing out!"
    rescue Bunny::ServerDownError
      puts "AMQP is down. Try again later, Sucka!"
    end
  
    # Mongoid
    Mongoid.configure do |config|
      Mongoid.from_hash FCG_CONFIG.mongodb.to_hash
      config.logger = LOGGER if defined? LOGGER
    end
    
    # Amazon Web Services
    AWS_ACCESS_KEY = ENV["AWS_ACCESS_KEY"]
    AWS_SECRET_KEY = ENV["AWS_SECRET_ACCESS_KEY"]
    
    # SimpleRecord is a proxy for Amazon SimpleDB
    SimpleRecord.establish_connection( AWS_ACCESS_KEY, AWS_SECRET_KEY)
    SimpleRecord::Base.set_domain_prefix("fcg_#{FCG_ENV}_")
      
    Dir[
      File.expand_path("../../lib/*.rb", __FILE__),
      File.expand_path("../../validators/*.rb", __FILE__),
      File.expand_path("../../models/*.rb", __FILE__),
      File.expand_path("../../apps/*.rb", __FILE__),
      File.expand_path("../../db/*.rb", __FILE__)
    ].each do |file|
      require file
    end
  end
rescue Gem::LoadError => e
  puts "Gems are loaded already"
end