# Setup Production Mode
# To run
# . pro_setup.sh
# Precomiple is needed for providing static files.

rake db:drop db:create db:migrate RAILS_ENV=production
rake db:seed RAILS_ENV=production
rake sunspot:reindex RAILS_ENV=production
