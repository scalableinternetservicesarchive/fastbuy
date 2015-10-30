# Setup Production Mode
# To run
# . pro_setup.sh

export SECRET_KEY_BASE=$(rake secret RAILS_ENV=production) 
rake sunspot:solr:stop
rake sunspot:solr:start
rake db:drop db:create db:migrate db:seed RAILS_ENV=production
rake sunspot:reindex
rake assets:precompile RAILS_ENV=production
