set :application, "dumbocms"
set :domain,      "uppereast.dumbocms.com:9922"

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
require "whenever/capistrano"

after "unicorn:reload", "whenever:update_crontab"

set :unicorn_bin, "/usr/local/bin/unicorn_rails"
require 'capistrano-unicorn'
