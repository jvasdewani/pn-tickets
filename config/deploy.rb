set :application, "pn-tickets"

set :branch, "master"

role :web, "192.168.20.3"                          # Your HTTP server, Apache/etc
role :app, "192.168.20.3"                          # This may be the same as your `Web` server
role :db,  "192.168.20.3"

set :rails_env, "production"
set :whenever_environment, "production"

default_run_options[:pty] = true  # Must be set for the password prompt
                                  # from git to work
set :repository, "git@github.com:codespectator/pn-tickets.git"  # Your clone URL
set :scm, "git"

set :deploy_to, "/var/app/pn-tickets"

set :user, "serveradmin"  # The server's user for deploys
set :use_sudo, false

set(:latest_release)  { fetch(:deploy_to) }
set(:release_path)    { fetch(:deploy_to) }
set(:current_release) { fetch(:deploy_to) }
set(:previous_release) { fetch(:deploy_to) }

set(:current_revision)  { capture("cd #{deploy_to}; git rev-parse --short HEAD").strip }
set(:latest_revision)   { capture("cd #{deploy_to}; git rev-parse --short HEAD").strip }
set(:previous_revision) { capture("cd #{deploy_to}; git rev-parse --short HEAD@{1}").strip }

set :bundle_without, [:development, :test, :assets]

set :unicorn_binary, "unicorn"
set :unicorn_config, "#{deploy_to}/config/unicorn.rb"
set :unicorn_pid, "/var/app/tmp/pids/unicorn.pid"

set :thin_binary, "thin"
set :thin_config, "#{deploy_to}/faye.ru"
set :thin_pid, "/var/app/tmp/pids/thin.pid"

set :whenever_command, "bundle exec whenever"

set(:sidekiq_role) { :app }

set :default_environment, {
  'LANG' => 'en_GB.UTF-8'
}

require 'bundler/capistrano'
require "whenever/capistrano"

namespace :deploy do

  before "deploy:start", "bundle:install"
  before "deploy:reload", "bundle:install"

  desc "Deploy the mutha-ucka"
  task :default do
    update_code
    restart
  end

  desc "Setup a GitHub-style deployment."
  task :setup, :except => { :no_release => true } do
    run "git clone -b #{branch} #{repository} #{deploy_to}"
  end

  desc "Update the deployed code."
  task :update_code, :except => { :no_release => true } do
    run "cd #{deploy_to}; git pull origin #{branch} "
  end

  task :start, :except => { :no_release => true }, :roles => :app do
    # puma.start
    unicorn.start
    sidekiq.start
    faye.start
  end

  task :stop, :except => { :no_release => true }, :roles => :app do
    # puma.stop
    unicorn.stop
    sidekiq.stop
    faye.stop
  end

  task :graceful_stop, :except => { :no_release => true }, :roles => :app do
    # puma.stop
    unicorn.stop
    sidekiq.stop
    faye.stop
  end

  task :restart, :except => { :no_release => true }, :roles => :app do
    # puma.restart
    unicorn.restart
    sidekiq.restart
    faye.restart
  end

  task :reload, :except => { :no_release => true }, :roles => :app do
    stop
    start
  end

  task :boot, :except => { :no_release => true }, :roles => :app do
    start
    sidekiq.start
    faye.start
  end
end

namespace :unicorn do
  task :start, :except => { :no_release => true }, :roles => :app do
    run "cd #{deploy_to}; bundle exec #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end

  task :stop, :except => { :no_release => true }, :roles => :app do
    run "kill -s TERM `cat #{unicorn_pid}`"
  end

  task :graceful_stop, :except => { :no_release => true }, :roles => :app do
    stop
  end

  task :restart, :except => { :no_release => true }, :roles => :app do
    run "kill -s USR2 `cat #{unicorn_pid}`"
  end

  task :reload, :except => { :no_release => true }, :roles => :app do
    stop
    start
  end
end

namespace :faye do
  task :start, :except => { :no_release => true }, :roles => :app do
    run "cd #{deploy_to}; bundle exec #{thin_binary} -R #{thin_config} -e #{rails_env} -d -a 192.168.20.3 -p 9292 -P #{thin_pid} start"
  end

  task :stop, :except => { :no_release => true }, :roles => :app do
    run "kill -s TERM `cat #{thin_pid}`"
  end

  task :graceful_stop, :except => { :no_release => true }, :roles => :app do
    stop
  end

  task :restart, :except => { :no_release => true }, :roles => :app do
    stop
    start
  end

  task :reload, :except => { :no_release => true }, :roles => :app do
    stop
    start
  end
end

namespace :assets do
  task :compile, :roles => :web, :except => { :no_release => true } do
    system %Q{bundle exec rake RAILS_ENV=#{rails_env} assets:precompile}
    system %Q{bundle exec rake RAILS_ENV=#{rails_env} assets:clean}
  end
end

set(:sidekiq_timeout) { 10 }

namespace :sidekiq do
  desc "Quiet sidekiq (stop accepting new work)"
  task :quiet, :roles => lambda { fetch(:sidekiq_role) }, :on_no_matching_servers => :continue do
    run "if [ -d /var/app/pn-tickets ] && [ -f /var/app/tmp/pids/sidekiq.pid ]; then cd /var/app/pn-tickets && #{fetch(:bundle_cmd, "bundle")} exec sidekiqctl quiet /var/app/tmp/pids/sidekiq.pid ; fi"
  end

  desc "Stop sidekiq"
  task :stop, :roles => lambda { fetch(:sidekiq_role) }, :on_no_matching_servers => :continue do
    run "if [ -d /var/app/pn-tickets ] && [ -f /var/app/tmp/pids/sidekiq.pid ]; then cd /var/app/pn-tickets && #{fetch(:bundle_cmd, "bundle")} exec sidekiqctl stop /var/app/tmp/pids/sidekiq.pid #{fetch :sidekiq_timeout} ; fi"
  end

  desc "Start sidekiq"
  task :start, :roles => lambda { fetch(:sidekiq_role) }, :on_no_matching_servers => :continue do
    rails_env = fetch(:rails_env, "production")
    run "cd /var/app/pn-tickets ; nohup #{fetch(:bundle_cmd, "bundle")} exec sidekiq -e #{rails_env} -c 5 -P /var/app/tmp/pids/sidekiq.pid >> /var/app/pn-tickets/log/sidekiq.log 2>&1 &", :pty => false
  end

  desc "Restart sidekiq"
  task :restart, :roles => lambda { fetch(:sidekiq_role) }, :on_no_matching_servers => :continue do
    stop
    start
  end

  desc "Flush the queue"
  task :flush do
    run "redis-cli FLUSHALL"
  end
end

namespace :cache do
  desc "Clear the cache"
  task :clean do
    run "echo \"flush_all\" | /bin/netcat -q 2 127.0.0.1 11211"
  end
end
