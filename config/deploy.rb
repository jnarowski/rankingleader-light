# required
set :application, "rankingleader_light"
set :deploy_to, "/var/www/rails/#{application}"
set :domain, "metajp.com"
set :repository,  "#{scm_username}@github.com:jnarowski/rankingleader-light.git"

# extra options
default_run_options[:pty] = true
set :use_sudo, false
set :shared_children, %w(system log pids config)

# defaults
role :app, domain
role :web, domain
role :db,  domain, :primary => true

namespace :deploy do
  task :start do; end
  task :stop do; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

#----------------------------------------------------------------
# hooks to setup all the fun
#----------------------------------------------------------------

after "deploy:symlink", "db:mysql:symlink"