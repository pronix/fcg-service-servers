# Please install the Engine Yard Capistrano gem
# gem install eycap --source http://gems.engineyard.com
require "eycap/recipes"

set :hostname, "service.fcgmedia.com"
set :keep_releases, 5
set :application,   'fcg-service-server'
set :repository,    'git@github.com:joemocha/fcg-service-servers.git'
set :deploy_to,     "/data/#{application}"
set :deploy_via,    :export
set :monit_group,   "#{application}"
set :scm,           :git
set :git_enable_submodules, 1
set :production_database, 'fcg_production'

set :environment_host, 'localhost'
set :deploy_via, :remote_cache

# uncomment the following to have a database backup done before every migration
# before "deploy:migrate", "db:dump"

# comment out if it gives you trouble. newest net/ssh needs this set.
ssh_options[:paranoid] = false
ssh_options[:forward_agent] = true
default_run_options[:pty] = true # required for svn+ssh:// and git:// sometimes
ssh_options[:keys] =  "~/.ssh/akuja-keypair"

# This will execute the Git revision parsing on the *remote* server rather than locally
set :real_revision, 			lambda { source.query_revision(revision) { |cmd| capture(cmd) } }

task :eventsimply_staging do
  role :web, '75.101.129.63' #ec2-75-101-129-63.compute-1.amazonaws.com
  role :app, '75.101.129.63'
  role :db,  '75.101.129.63', :primary => true
  
  set :environment_database, Proc.new { production_database }
  set :dbuser,        'deploy'
  set :dbpass,        'Gile7bZMZt'
  set :user,          'deploy'
  set :password,      'Gile7bZMZt'
  set :runner,        'deploy'
  set :rack_env,      'production'
end

# TASKS
# Don't change unless you know what you are doing!

after "deploy", "deploy:cleanup"
after "deploy:migrations", "deploy:cleanup"
after "deploy:update_code","deploy:symlink_configs"

namespace :deploy do
  desc "Update the crontab file"
  task :update_crontab, :roles => :app do
    run "cd #{release_path} && whenever --set environment=#{rack_env} --write-crontab #{application}"
  end
  
  desc "seed database after cold deploy"
  task :seed_db, :roles => :app do
    run "cd #{release_path} && RAILS_ENV=#{rack_env} rake db:seed_fu"
  end
end