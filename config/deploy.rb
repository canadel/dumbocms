require "bundler/capistrano"

set :application, "dumbocms"
set :domain,      "37.235.63.140"

set :user,        "#{application}"

set :repository,  "git@github.com:canadel/#{application}.git"
set :scm,         :git

set :deploy_to,   "/home/#{application}/production"

set :use_sudo,    false
set :rake,        "bundle exec rake"

role :web,        "#{domain}"
role :app,        "#{domain}"
role :db,         "#{domain}", :primary => true

ssh_options[:forward_agent] = true

set :rails_env,   :production

set :whenever_command, "bundle exec whenever"

#require "whenever/capistrano"

# namespace :bundle do
#   desc "run bundle install and ensure all gem requirements are met"
#   task :install do
#     run "cd #{current_path} && bundle install --without test"
#   end
# end

#after "unicorn:reload", "whenever:update_crontab"
#after "unicorn:reload", "bundle:install"

#set :unicorn_bin, "/usr/local/bin/unicorn_rails"

#require 'capistrano-unicorn'
