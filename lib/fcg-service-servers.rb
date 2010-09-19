# models, helpers
Dir[
  File.expand_path("../fcg-service-servers/**/*.rb", __FILE__)
].each do |file|
  puts file
  require file
end