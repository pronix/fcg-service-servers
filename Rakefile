require 'rake'

dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift dir + 'lib/fcg-service-servers'
require 'fcg-service-servers/version'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "fcg-service-servers"
    gem.summary = %Q{FCG Service Servers}
    gem.description = %Q{Servers for the different services offered by FCG}
    gem.email = "sam@fcgmedia.com"
    gem.homepage = "http://github.com/joemocha/fcg-service-servers"
    gem.authors = ["Samuel O. Obukwelu"]
    gem.add_development_dependency "mocha", ">= 0.9.0"
    gem.add_development_dependency "rspec", ">= 2.0.0" # ">= 2.0.0.beta.20"
    gem.add_development_dependency "rack-test", ">= 0.5.6"
    gem.add_development_dependency "fabrication", ">= 0.8.3"
    gem.add_development_dependency "database_cleaner"
    gem.add_development_dependency "ffaker", ">= 0.4.0"
    gem.add_development_dependency "ruby-debug"
    gem.add_development_dependency "timecop"
    
    gem.add_dependency "fcg-core-ext", ">= 0.0.4"
    gem.add_dependency "fcg-service-ext", ">= 0.0.11"
    gem.add_dependency "thor"
    gem.add_dependency "thin", "1.2.7"
    gem.add_dependency "sinatra", ">= 1.0"
    gem.add_dependency "bson_ext", ">= 1.0.9"
    gem.add_dependency "mongoid", "2.0.0.beta.19"
    gem.add_dependency "rack-mount", ">= 0.6.13"
    gem.add_dependency "vegas", ">= 0.1.7"
    gem.add_dependency "bunny"
    gem.add_dependency "fastercsv", ">= 1.5.3"
    gem.add_dependency "sanitize"
    gem.add_dependency "ice_cube", ">= 0.5.9"
    gem.add_dependency "rdiscount", ">= 1.6.5"
    gem.add_dependency "transitions"
    gem.add_dependency "msgpack"
    
    # Redis
    gem.add_dependency "SystemTimer"
    gem.add_dependency "redis", ">= 2.0.10"
    gem.add_dependency "redis-namespace", ">= 0.10.0"
    gem.add_dependency "redisk"
    
    gem.executables = ["fcg-service-server"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
    gem.version = FCG::Server::VERSION
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb"]
  t.pattern = 'spec/**/*_spec.rb'
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.rcov_opts =  %q[--exclude "spec"]
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "fcg-service-servers #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

namespace :seed do
  desc "Seed redis with site data"
  task :sites do
    require "lib/fcg-service-servers"
    Seed::create_sites
  end

  desc "Populate Redis with US geographic data"
  task :us_geodata do
    require "lib/fcg-service-servers"
    Seed::create_geodata
  end
end
