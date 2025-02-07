# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'caodoo'
set :repo_url, 'git@github.com:cntoplolicon/caodoo.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, :release

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/caodoo'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
 set :pty, true

# Default value for :linked_files is []
 set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml',
                                                  'config/shards.yml', 'config/redis.yml',
                                                  'config/cdn.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
set :whenever_roles, ->{ :batch }

namespace :deploy do
  desc "reload the database with seed data"
  task :seed do
    on primary fetch(:migration_role) do
      within release_path do
        with rails_env: fetch(:rails_env)  do
          execute :rake, 'db:seed'
        end
      end
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
