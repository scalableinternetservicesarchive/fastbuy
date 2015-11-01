# Setup Production Mode
# To run
# . pro_setup.sh
# Precomiple is needed for providing static files.

export SECRET_KEY_BASE=$(rake secret RAILS_ENV=production) 
rake db:drop db:create db:migrate RAILS_ENV=production
rake db:seed RAILS_ENV=production
rake sunspot:reindex RAILS_ENV=production
rake assets:precompile RAILS_ENV=production
export REDIS_PATH=$PWD/../redis-stable/src

