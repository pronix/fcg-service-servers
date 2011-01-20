require "bundler/capistrano"
require "fog"

AWS = Fog::Compute.new(
  :provider                 => 'AWS',
  :aws_secret_access_key    => ENV["AWS_SECRET_ACCESS_KEY"],
  :aws_access_key_id        => ENV["AWS_ACCESS_KEY"]
)

set :application,               "fcg-service"
set :security_group,            "fcg-service"
set :user,                      "deploy"
set :group,                     "deploy"
set :keep_releases,             3
set :checkout,                  "export"
set :deploy_to,                 "/data/#{application}"
set :shared_children,           %w(system log pids config config/settings tmp repository public)
set :repository,                "git@github.com:joemocha/fcg-service-servers.git"
set :scm, :git                  
set :copy_exclude,              [".git", ".gitignore", "log/*", "tmp/*"]
set :deploy_via,                :export
set :copy_cache,                true
set :chmod755,                  %w(config lib public vendor tmp)
set :thin_server_size,          3
set :rack_env,                  "production"

ssh_options[:forward_agent] =   true
ssh_options[:auth_methods] =    "publickey"
ssh_options[:keys] =            "~/.ssh/akuja-keypair"


ip_addresses = begin
  AWS.servers.all.find_all{|s| s.groups.include?(security_group) }.map{|s| s.ip_address }.join(",")
end

role :web, ip_addresses
role :app, ip_addresses
role :db,  ip_addresses, :primary => true

namespace :deploy do
  task :restart, :roles => [:app] do
    run "cd #{deploy_to}/current && bundle exec /etc/init.d/thin restart"
  end
  
  task :start, :roles => [:app] do
    run "cd #{deploy_to}/current && bundle exec /etc/init.d/thin start"
  end
  
  task :stop, :roles => [:app] do
    run "cd #{deploy_to}/current && bundle exec /etc/init.d/thin stop"
  end
  
  task :new_symlinks, :role => [:app] do
    {
     "config/settings/amqp.yml"     => "lib/fcg-service-servers/config/settings/amqp.yml",
     "config/settings/aws.yml"      => "lib/fcg-service-servers/config/settings/aws.yml",
     "config/settings/mongodb.yml"  => "lib/fcg-service-servers/config/settings/mongodb.yml",
     "config/settings/redis.yml"    => "lib/fcg-service-servers/config/settings/redis.yml",
     "public"                       => "public"
    }.each_pair do |key, value|
      run "ln -nfs #{deploy_to}/#{shared_dir}/#{key} #{release_path}/#{value}"
    end
  end
  
  task :change_ownership do
    sudo "chown -R #{user}:#{group} #{deploy_to}"
  end
  
  task :touch_initial_files do
    run "touch #{deploy_to}/shared/log/production.log &&\
    touch #{deploy_to}/shared/public/index.html"
  end
  
  task :seeds do
    run 
  end
end

after "deploy:setup", "deploy:change_ownership", "deploy:touch_initial_files", "thin"
after "deploy:symlink", "deploy:new_symlinks"

namespace :thin do
  task :install_gem do
    sudo "gem install thin --no-ri --no-rdoc"
  end
  
  task :install_startup_script do
    sudo "thin install"
  end
  
  task :create_config do
    sudo "thin config -C /etc/thin/#{application}.yml -c #{deploy_to}/current \
    --servers #{thin_server_size} --socket /tmp/thin.#{application}.sock -O \
    -e #{rack_env} -u #{user} -g #{group} -A rack -R config.ru"
  end
  
  task :start_at_boot_time do
    sudo "/usr/sbin/update-rc.d -f thin defaults"
  end
  
  task :default do
    install_gem
    install_startup_script
    start_at_boot_time
    create_config
  end
end