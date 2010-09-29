require "fcg-service-ext"
dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift dir + 'fcg-service-servers'

Dir[
  File.expand_path("../fcg-service-servers/version.rb", __FILE__),
  File.expand_path("../fcg-service-servers/config/boot.rb", __FILE__)
].each do |file|
  require file
end