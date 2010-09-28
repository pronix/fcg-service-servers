# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fcg-service-servers}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Samuel O. Obukwelu"]
  s.date = %q{2010-09-27}
  s.default_executable = %q{fcg-service-server}
  s.description = %q{Servers for the different services offered by FCG}
  s.email = %q{sam@fcgmedia.com}
  s.executables = ["fcg-service-server"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "Gemfile",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "bin/fcg-service-server",
     "config.ru",
     "fcg-service-servers.gemspec",
     "lib/fcg-service-servers.rb",
     "lib/fcg-service-servers/apps.rb",
     "lib/fcg-service-servers/apps/activity_app.rb",
     "lib/fcg-service-servers/apps/event_app.rb",
     "lib/fcg-service-servers/apps/stat_app.rb",
     "lib/fcg-service-servers/apps/user_app.rb",
     "lib/fcg-service-servers/apps/venue_app.rb",
     "lib/fcg-service-servers/config/boot.rb",
     "lib/fcg-service-servers/config/settings/amqp.yml",
     "lib/fcg-service-servers/config/settings/app.yml",
     "lib/fcg-service-servers/config/settings/app.yml.temp",
     "lib/fcg-service-servers/config/settings/redis.yml",
     "lib/fcg-service-servers/lib/service.rb",
     "lib/fcg-service-servers/models/activity.rb",
     "lib/fcg-service-servers/models/event.rb",
     "lib/fcg-service-servers/models/user.rb",
     "lib/fcg-service-servers/models/venue.rb",
     "lib/fcg-service-servers/validators/user_validator.rb",
     "lib/fcg-service-servers/version.rb",
     "spec/activity_app_spec.rb",
     "spec/servers_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/test_helper.rb",
     "spec/user_app_spec.rb"
  ]
  s.homepage = %q{http://github.com/joemocha/fcg-service-servers}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{FCG Service Servers}
  s.test_files = [
    "spec/activity_app_spec.rb",
     "spec/servers_spec.rb",
     "spec/spec_helper.rb",
     "spec/test_helper.rb",
     "spec/user_app_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.3.0"])
      s.add_development_dependency(%q<rack-test>, [">= 0.5.6"])
      s.add_runtime_dependency(%q<SystemTimer>, [">= 0"])
      s.add_runtime_dependency(%q<fcg-core-ext>, [">= 0"])
      s.add_runtime_dependency(%q<fcg-service-ext>, [">= 0.0.11"])
      s.add_runtime_dependency(%q<thin>, [">= 0"])
      s.add_runtime_dependency(%q<sinatra>, [">= 1.0"])
      s.add_runtime_dependency(%q<bson>, [">= 1.0.9"])
      s.add_runtime_dependency(%q<bson_ext>, [">= 1.0.9"])
      s.add_runtime_dependency(%q<mongo_mapper>, [">= 0.8.4"])
      s.add_runtime_dependency(%q<hashie>, [">= 0"])
      s.add_runtime_dependency(%q<bunny>, [">= 0"])
      s.add_runtime_dependency(%q<redis>, [">= 0"])
      s.add_runtime_dependency(%q<yajl-ruby>, [">= 0.7.7"])
      s.add_runtime_dependency(%q<rack-mount>, [">= 0.6.13"])
      s.add_runtime_dependency(%q<vegas>, [">= 0.1.7"])
    else
      s.add_dependency(%q<rspec>, [">= 1.3.0"])
      s.add_dependency(%q<rack-test>, [">= 0.5.6"])
      s.add_dependency(%q<SystemTimer>, [">= 0"])
      s.add_dependency(%q<fcg-core-ext>, [">= 0"])
      s.add_dependency(%q<fcg-service-ext>, [">= 0.0.11"])
      s.add_dependency(%q<thin>, [">= 0"])
      s.add_dependency(%q<sinatra>, [">= 1.0"])
      s.add_dependency(%q<bson>, [">= 1.0.9"])
      s.add_dependency(%q<bson_ext>, [">= 1.0.9"])
      s.add_dependency(%q<mongo_mapper>, [">= 0.8.4"])
      s.add_dependency(%q<hashie>, [">= 0"])
      s.add_dependency(%q<bunny>, [">= 0"])
      s.add_dependency(%q<redis>, [">= 0"])
      s.add_dependency(%q<yajl-ruby>, [">= 0.7.7"])
      s.add_dependency(%q<rack-mount>, [">= 0.6.13"])
      s.add_dependency(%q<vegas>, [">= 0.1.7"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.3.0"])
    s.add_dependency(%q<rack-test>, [">= 0.5.6"])
    s.add_dependency(%q<SystemTimer>, [">= 0"])
    s.add_dependency(%q<fcg-core-ext>, [">= 0"])
    s.add_dependency(%q<fcg-service-ext>, [">= 0.0.11"])
    s.add_dependency(%q<thin>, [">= 0"])
    s.add_dependency(%q<sinatra>, [">= 1.0"])
    s.add_dependency(%q<bson>, [">= 1.0.9"])
    s.add_dependency(%q<bson_ext>, [">= 1.0.9"])
    s.add_dependency(%q<mongo_mapper>, [">= 0.8.4"])
    s.add_dependency(%q<hashie>, [">= 0"])
    s.add_dependency(%q<bunny>, [">= 0"])
    s.add_dependency(%q<redis>, [">= 0"])
    s.add_dependency(%q<yajl-ruby>, [">= 0.7.7"])
    s.add_dependency(%q<rack-mount>, [">= 0.6.13"])
    s.add_dependency(%q<vegas>, [">= 0.1.7"])
  end
end

