require 'rake'
require 'bundler'

dir = File.dirname(File.expand_path(__FILE__))
# $LOAD_PATH.unshift dir + '/lib/fcg-service-servers'
require 'lib/fcg-service-servers/version'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "fcg-service-servers"
    gem.summary = %Q{FCG Service Servers}
    gem.description = %Q{Servers for the different services offered by FCG}
    gem.email = "sam@fcgmedia.com"
    gem.homepage = "http://github.com/joemocha/fcg-service-servers"
    gem.authors = ["Samuel O. Obukwelu"]
    # for bundler
    gem.add_bundler_dependencies
    
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

namespace :chef do
  TOPDIR = File.dirname(__FILE__)

  desc "Test your cookbooks for syntax errors"
  task :test do
    puts "** Testing your cookbooks for syntax errors"
    Dir[ File.join(TOPDIR, "cookbooks", "**", "*.rb") ].each do |recipe|
      sh %{ruby -c #{recipe}} do |ok, res|
        if ! ok
          raise "Syntax error in #{recipe}"
        end
      end
    end
  end

  desc "By default, run rake test"
  task :default => [ :test ]

  desc "Create a new cookbook (with COOKBOOK=name)"
  task :new_cookbook do
    create_cookbook(File.join(TOPDIR, "cookbooks"))
  end

  def create_cookbook(dir)
    raise "Must provide a COOKBOOK=" unless ENV["COOKBOOK"]
    puts "** Creating cookbook #{ENV["COOKBOOK"]}"
    sh "mkdir -p #{File.join(dir, ENV["COOKBOOK"], "attributes")}" 
    sh "mkdir -p #{File.join(dir, ENV["COOKBOOK"], "recipes")}" 
    sh "mkdir -p #{File.join(dir, ENV["COOKBOOK"], "definitions")}" 
    sh "mkdir -p #{File.join(dir, ENV["COOKBOOK"], "libraries")}" 
    sh "mkdir -p #{File.join(dir, ENV["COOKBOOK"], "files", "default")}" 
    sh "mkdir -p #{File.join(dir, ENV["COOKBOOK"], "templates", "default")}" 
    unless File.exists?(File.join(dir, ENV["COOKBOOK"], "recipes", "default.rb"))
      open(File.join(dir, ENV["COOKBOOK"], "recipes", "default.rb"), "w") do |file|
        file.puts <<-EOH
  #
  # Cookbook Name:: #{ENV["COOKBOOK"]}
  # Recipe:: default
  #
  EOH
      end
    end
  end
  TOPDIR = File.dirname(__FILE__)

  desc "Test your cookbooks for syntax errors"
  task :test do
    puts "** Testing your cookbooks for syntax errors"
    Dir[ File.join(TOPDIR, "cookbooks", "**", "*.rb") ].each do |recipe|
      sh %{ruby -c #{recipe}} do |ok, res|
        if ! ok
          raise "Syntax error in #{recipe}"
        end
      end
    end
  end

  desc "By default, run rake test"
  task :default => [ :test ]

  desc "Create a new cookbook (with COOKBOOK=name)"
  task :new_cookbook do
    create_cookbook(File.join(TOPDIR, "cookbooks"))
  end

  def create_cookbook(dir)
    raise "Must provide a COOKBOOK=" unless ENV["COOKBOOK"]
    puts "** Creating cookbook #{ENV["COOKBOOK"]}"
    sh "mkdir -p #{File.join(dir, ENV["COOKBOOK"], "attributes")}" 
    sh "mkdir -p #{File.join(dir, ENV["COOKBOOK"], "recipes")}" 
    sh "mkdir -p #{File.join(dir, ENV["COOKBOOK"], "definitions")}" 
    sh "mkdir -p #{File.join(dir, ENV["COOKBOOK"], "libraries")}" 
    sh "mkdir -p #{File.join(dir, ENV["COOKBOOK"], "files", "default")}" 
    sh "mkdir -p #{File.join(dir, ENV["COOKBOOK"], "templates", "default")}" 
    unless File.exists?(File.join(dir, ENV["COOKBOOK"], "recipes", "default.rb"))
      open(File.join(dir, ENV["COOKBOOK"], "recipes", "default.rb"), "w") do |file|
        file.puts <<-EOH
  #
  # Cookbook Name:: #{ENV["COOKBOOK"]}
  # Recipe:: default
  #
  EOH
      end
    end
  end
end