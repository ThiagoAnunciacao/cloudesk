require "bundler/capistrano"

set :application, "teste"

set :bundle_cmd, 'source $HOME/.bash_profile'

# set :bundle_cmd, 'source $HOME/.bash_profile && bundle'

set :scm,             :git
set :repository,      "git@github.com:ThiagoAnunciacao/cloudesk.git"
set :branch,          "origin/master"
set :migrate_target,  :current
# set :ssh_options,     { :forward_agent => true }
set :rails_env,       "production"
set :deploy_to,       "/home/deployer/apps/teste"
set :normalize_asset_timestamps, false

set :user,            "deployer"
set :group,           "staff"
set :use_sudo,        true

role :web,    "67.207.152.23"
role :app,    "67.207.152.23"
role :db,     "db.cloudesk.com.br", :primary => true

set(:latest_release)  { fetch(:current_path) }
set(:release_path)    { fetch(:current_path) }
set(:current_release) { fetch(:current_path) }

set(:current_revision)  { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:latest_revision)   { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:previous_revision) { capture("cd #{current_path}; git rev-parse --short HEAD@{1}").strip }

default_environment["RAILS_ENV"] = 'production'

# Use our ruby-1.9.2-p290@my_site gemset
# default_environment["PATH"]         = "/home/deployer/.rvm/gems/ruby-1.9.3-p392/bin:/home/deployer/.rvm/gems/ruby-1.9.3-p392@global/bin:/home/deployer/.rvm/rubies/ruby-1.9                           .3-p392/bin:/home/deployer/.rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/local/rvm/bin"
# default_environment["GEM_HOME"]     = "/home/deployer/.rvm/gems/ruby-1.9.3-p392"
# default_environment["GEM_PATH"]     = "/home/deployer/.rvm/gems/ruby-1.9.3-p392:/home/deployer/.rvm/gems/ruby-1.9.3-p392@global"
default_environment["RUBY_VERSION"] = "ruby-1.9.3-p392"

default_run_options[:shell] = 'bash'

# namespace :deploy do
#   desc "Deploy your application"
#   task :default do
#     update
#     restart
#   end

#   desc "Setup your git-based deployment app"
#   task :setup, :except => { :no_release => true } do
#     dirs = [deploy_to, shared_path]
#     dirs += shared_children.map { |d| File.join(shared_path, d) }
#     run "#{try_sudo} mkdir -p #{dirs.join(' ')} && #{try_sudo} chmod g+w #{dirs.join(' ')}"
#     run "git clone #{repository} #{current_path}"
#   end

#   task :cold do
#     update
#     migrate
#   end

#   task :update do
#     transaction do
#       update_code
#     end
#   end

#   desc "Update the deployed code."
#   task :update_code, :except => { :no_release => true } do
#     run "cd #{current_path}; git fetch origin; git reset --hard #{branch}"
#     finalize_update
#   end

#   desc "Update the database (overwritten to avoid symlink)"
#   task :migrations do
#     transaction do
#       update_code
#     end
#     migrate
#     restart
#   end

#   task :finalize_update, :except => { :no_release => true } do
#     run "chmod -R g+w #{latest_release}" if fetch(:group_writable, true)

#     # mkdir -p is making sure that the directories are there for some SCM's that don't
#     # save empty folders
#     run <<-CMD
#       rm -rf #{latest_release}/log #{latest_release}/public/system #{latest_release}/tmp/pids &&
#       mkdir -p #{latest_release}/public &&
#       mkdir -p #{latest_release}/tmp &&
#       ln -s #{shared_path}/log #{latest_release}/log &&
#       ln -s #{shared_path}/system #{latest_release}/public/system &&
#       ln -s #{shared_path}/tmp/pids #{latest_release}/tmp/ &&
#       ln -sf #{shared_path}/database.yml #{latest_release}/config/database.yml
#     CMD

#     if fetch(:normalize_asset_timestamps, true)
#       stamp = Time.now.utc.strftime("%Y%m%d%H%M.%S")
#       asset_paths = fetch(:public_children, %w(images stylesheets javascripts)).map { |p| "#{latest_release}/public/#{p}" }.join(" ")
#       run "find #{asset_paths} -exec touch -t #{stamp} {} ';'; true", :env => { "TZ" => "UTC" }
#     end
#   end

#   desc "Zero-downtime restart of Unicorn"
#   task :restart, :except => { :no_release => true } do
#     run "kill -s USR2 `cat /tmp/pids/unicorn.teste.pid`"
#   end

#   desc "Start unicorn"
#   task :start, :except => { :no_release => true } do
#     run "cd #{current_path} ; bundle exec unicorn_rails -c config/unicorn.rb -D"
#   end

#   desc "Stop unicorn"
#   task :stop, :except => { :no_release => true } do
#     run "kill -s QUIT `cat /tmp/pids/unicorn.teste.pid`"
#   end

#   namespace :rollback do
#     desc "Moves the repo back to the previous version of HEAD"
#     task :repo, :except => { :no_release => true } do
#       set :branch, "HEAD@{1}"
#       deploy.default
#     end

#     desc "Rewrite reflog so HEAD@{1} will continue to point to at the next previous release."
#     task :cleanup, :except => { :no_release => true } do
#       run "cd #{current_path}; git reflog delete --rewrite HEAD@{1}; git reflog delete --rewrite HEAD@{1}"
#     end

#     desc "Rolls back to the previously deployed version."
#     task :default do
#       rollback.repo
#       rollback.cleanup
#     end
#   end
# end

namespace :deploy do
  desc "Zero-downtime restart of Unicorn"
  task :restart, roles: :app, :except => { :no_release => true } do
    run "kill -s USR2 `cat /tmp/unicorn.teste.pid`"
  end
 
  desc "Start Unicorn"
  task :start, roles: :app, :except => { :no_release => true } do
    run "cd #{current_path} ; bundle exec unicorn_rails -c config/unicorn.rb -D"
  end
 
  desc "Stop Unicorn"
  task :stop, roles: :app, :except => { :no_release => true } do
    run "kill -s QUIT `cat /tmp/unicorn.teste.pid`"
  end 
 
  namespace :assets do
    desc <<-DESC
      Run the asset precompilation rake task. You can specify the full path \
      to the rake executable by setting the rake variable. You can also \
      specify additional environment variables to pass to rake via the \
      asset_env variable. The defaults are:
 
        set :rake,      "rake"
        set :rails_env, "production"
        set :asset_env, "RAILS_GROUPS=assets"
 
      * only runs if assets have changed (add `-s force_assets=true` to force precompilation)
    DESC
    task :precompile, :roles => :web, :except => { :no_release => true } do
      # Only precompile assets if any assets changed
      # http://www.bencurtis.com/2011/12/skipping-asset-compilation-with-capistrano/
      from = source.next_revision(current_revision)
      if fetch(:force_assets, false) || capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ lib/assets/ | wc -l").to_i > 0
        # Just like original: https://github.com/capistrano/capistrano/blob/master/lib/capistrano/recipes/deploy/assets.rb
        run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile"
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end
end

def run_rake(cmd)
  run "cd #{current_path}; #{rake} #{cmd}"
end