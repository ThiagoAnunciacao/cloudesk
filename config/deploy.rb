application = "teste"
repository = 'git@github.com:ThiagoAnunciacao/cloudesk.git'
hosts = []

# OPTIONALS

before_restarting_server do
  rake "important:task"
  run "important_command"
end

path = '/apps'                        	     # default /var/local/apps
user = 'deployer'                              # default deploy
ssh_opts = '-A'                              # default empty
branch = 'master'                       # default master
environment = 'production'                      # default production
sudo = true                                  # default false
cache_dirs = ['public/cache', 'tmp/cache']   # default ['public/cache']
skip_steps = [] # default []
app_folder = ''                # default empty
login_shell = false                           # default false
bundler_opts = '--deployment --without development test cucumber'                  # default '--deployment --without development test cucumber'