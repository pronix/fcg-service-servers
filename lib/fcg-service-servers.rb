require "fcg-service-ext"
# models, helpers
Dir[
  File.expand_path("../fcg-service-servers/version.rb", __FILE__),,
  File.expand_path("../fcg-service-servers/config/boot.rb", __FILE__)
].each do |file|
  require file
end