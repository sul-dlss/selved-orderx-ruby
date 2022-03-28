# frozen_string_literal: true

set :application, 'selved-orderx-ruby'
set :repo_url, 'https://github.com/sul-dlss/selved-orderx-ruby.git'
set :user, 'sirsi'

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default value for :log_level is :debug
set :log_level, :info

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/s/SUL/Bin/SelvedWrapper/#{fetch(:application)}"

# Default value for linked_dirs is []
# set :linked_dirs, %w[]

# Default value for keep_releases is 5
set :keep_releases, 3

set :rvm_ruby_version, '2.7.1'
