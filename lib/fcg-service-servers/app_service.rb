require "rubygems"
require "fcg-service-ext"
require "http_router"

Dir[
  File.expand_path("../apps/*.rb", __FILE__)
].each do |file|
  puts file
  require file
end

HttpRouter.override_rack_mapper!

run HttpRouter.new do
  add("/api/#{API_VERSION}/users").to(FCG::UserService)
  add("/api/#{API_VERSION}/activities").to(FCG::ActivityService)
end