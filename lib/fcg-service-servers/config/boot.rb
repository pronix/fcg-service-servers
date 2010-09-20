env_arg = ARGV.index("-e")
FCG_ENV = (env_arg || ENV["SINATRA_ENV"] || "development").to_sym 

# Redisk.redis = 'myhost:myport'
# logger = Logger.new(Redisk::IO.new("#{FCG_ENV}.log"))

configure do
  FCG_CONFIG = %w(app).inject({}) do |result, file|
    raw_config = File.read(File.expand_path("../settings/#{file}.yml", __FILE__))
    result[file.to_sym]= YAML.load(raw_config)[FCG_ENV.to_s]
    result
  end

  API_VERSION = FCG_CONFIG[:app]["version"]

  MongoMapper.connection = Mongo::Connection.new('localhost', nil, :logger => nil)
  MongoMapper.database = "fcg_#{FCG_ENV}"
end