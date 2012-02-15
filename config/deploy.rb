set :rails_env, "production"

set :verbose, true

set :application, "dumbocms"
set :domain, "108.166.65.97"

set :user, "dumbocms"
set :password, "JoktefOc:"

set :scm, "git"
set :scm_verbose, true
set :repository, "git@github.com:maurycy/dumbocms.git"

set :branch, "origin/master"

set :deploy_to, "/home/dumbocms/apps/#{rails_env}"
set :deploy_via, :remote_cache
set :keep_releases, 5
set :use_sudo, false

role :app, domain
role :web, domain
role :db,  domain, :primary => true

set :rake, 'rake --trace'

after "deploy:symlink", "deploy:update_crontab"

namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && whenever --update-crontab #{application}"
  end
end

