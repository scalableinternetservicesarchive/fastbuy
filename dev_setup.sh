# Setup Development Mode
# To run:
# sh dev_setup.sh or . dev_setup.sh
# Notice: In VM, the env is development as default.
# Install mysql if bundle fails.
# sudo yum install mysql-devel

rake db:drop db:create db:migrate RAILS_ENV=development
rake db:seed RAILS_ENV=development
rake sunspot:solr:reindex RAILS_ENV=development 
