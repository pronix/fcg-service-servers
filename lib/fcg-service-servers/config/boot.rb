require "bundler"
env_arg = ARGV.index("-e")
FCG_ENV = (env_arg || ENV["RACK_ENV"] || "development").to_sym unless defined? FCG_ENV
begin
  Bundler.setup
  Bundler.require(:default, FCG_ENV)

  configure do
  
    FCG_CONFIG = %w(app amqp aws redis mongodb image).inject(Hashie::Mash.new) do |result, file|
      raw_config = ERB.new(File.read(File.expand_path("../settings/#{file}.yml", __FILE__))).result
      result[file.to_sym]= Hashie::Mash.new(YAML.load(raw_config)[FCG_ENV.to_s])
      result
    end unless defined? FCG_CONFIG
    
    # Amazon Web Services
    if FCG_CONFIG.aws.nil? or FCG_CONFIG.aws.access_key.nil? or FCG_CONFIG.aws.secret_access_key.nil?
      raise "Set access_key and secret_access_key in config/settings/aws.yml" 
    end
    
    AWS = Fog::Compute.new(
    :provider                 => 'AWS',
    :aws_secret_access_key    => FCG_CONFIG.aws.secret_access_key,
    :aws_access_key_id => FCG_CONFIG.aws.access_key
    )
    
    # SimpleRecord is a proxy for Amazon SimpleDB
    SimpleRecord::Base.set_domain_prefix("fcg_#{FCG_ENV}_")
    SimpleRecord.establish_connection( FCG_CONFIG.aws.access_key, FCG_CONFIG.aws.secret_access_key, :connection_mode => :per_thread)
  
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
      end
    rescue Qrack::ConnectionTimeout
      LOGGER.info "ASYNC_CLIENT is timing out!"
    rescue Bunny::ServerDownError
      LOGGER.info "AMQP is down. Try again later, Sucka!"
    end
  
    # Mongoid
    Mongoid.configure do |config|
      Mongoid.from_hash FCG_CONFIG.mongodb.to_hash
      config.logger = LOGGER if defined? LOGGER
    end
      
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
  LOGGER.info "Gems are loaded already"
end