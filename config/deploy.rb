require "bundler/capistrano"

set :user,      "deploy"
set :password,      "Ifejika9"
set :keep_releases, 3
set :checkout,      "export"
set :application,   "fcg_service"
set :deploy_to, "/data/#{application}"

default_run_options[:pty] = true
set :shared_dir, "shared"
set :repository,  "git@github.com:joemocha/fcg-service-servers.git"
# set :branch, "master"
set :scm, :git
set :copy_exclude, [".git", ".gitignore", "log/*", "tmp/*"]
set :deploy_via, :export # :copy
set :copy_cache, false
set :chmod755, %w(config lib public vendor tmp)

ssh_options[:username] = "deploy"
ssh_options[:forward_agent] =  true
# ssh_options[:verbose] = :debug
ssh_options[:auth_methods] = %w(password keyboard-interactive publickey)
ssh_options[:keys] =  "~/.ssh/akuja-keypair"

role :web, "72.44.58.98"
role :app, "72.44.58.98"
role :db,  "72.44.58.98", :primary => true

namespace :deploy do
  task :restart, :roles => [:app] do
    run "/etc/init.d/thin restart"
  end
  
  task :start, :roles => [:app] do
    run "/etc/init.d/thin start"
  end
  
  task :stop, :roles => [:app] do
    run "/etc/init.d/thin stop"
  end
end