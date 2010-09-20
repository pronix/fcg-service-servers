require "bundler"

env_arg = ARGV.index("-e")
FCG_ENV = (env_arg || ENV["SINATRA_ENV"] || "development").to_sym 

Bundler.setup
Bundler.require(:default, FCG_ENV)

# Redisk.redis = 'myhost:myport'
# logger = Logger.new(Redisk::IO.new("#{FCG_ENV}.log"))

configure do
  FCG_CONFIG = %w(app).inject({}) do |result, file|
    raw_config = File.read(File.expand_path("../settings/#{file}.yml", __FILE__))
    result[file.to_sym]= YAML.load(raw_config)[FCG_ENV.to_s]
    result
  end# unless const_defined? :FCG_CONFIG

  API_VERSION = FCG_CONFIG[:app]["version"]# unless const_defined? :API_VERSION

  MongoMapper.connection = Mongo::Connection.new('localhost', nil, :logger => nil)
  MongoMapper.database = "fcg_#{FCG_ENV}"
  
  # Load all necessary files
  Dir[
    File.expand_path("../../lib/cattr_inheritable_attrs.rb", __FILE__),
    File.expand_path("../../lib/service.rb", __FILE__),
    File.expand_path("../../validators/*.rb", __FILE__),
    File.expand_path("../../models/*.rb", __FILE__),
    File.expand_path("../../apps/*.rb", __FILE__)
  ].each do |file|
    require file
  end
end