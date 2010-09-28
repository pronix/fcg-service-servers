require 'rubygems'
require 'rake'
require 'lib/fcg-service-servers/version.rb'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "fcg-service-servers"
    gem.summary = %Q{FCG Service Servers}
    gem.description = %Q{Servers for the different services offered by FCG}
    gem.email = "sam@fcgmedia.com"
    gem.homepage = "http://github.com/joemocha/fcg-service-servers"
    gem.authors = ["Samuel O. Obukwelu"]
    gem.add_development_dependency "rspec", ">= 1.3.0"
    gem.add_development_dependency "rack-test", ">= 0.5.6"
    gem.add_dependency "SystemTimer"
    gem.add_dependency "fcg-core-ext"
    gem.add_dependency "fcg-service-ext", ">= 0.0.11"
    gem.add_dependency "thin"
    gem.add_dependency "sinatra", ">= 1.0"
    gem.add_dependency "bson", ">= 1.0.9"
    gem.add_dependency "bson_ext", ">= 1.0.9"
    gem.add_dependency "mongo_mapper", ">= 0.8.4"
    gem.add_dependency "hashie"
    gem.add_dependency "bunny"
    gem.add_dependency "redis"
    gem.add_dependency "yajl-ruby", ">= 0.7.7"
    gem.add_dependency "rack-mount", ">= 0.6.13"
    gem.add_dependency "vegas", ">= 0.1.7"
    
    gem.executables = ["fcg-service-server"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
    gem.version = FCG::Server::VERSION
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
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
