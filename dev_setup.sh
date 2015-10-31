#To run:
#sh dev_setup.sh or . dev_setup
#Notice: In VM, the env is development as default.

RAILS_ENV=development rake sunspot:solr:stop
RAILS_ENV=development rake sunspot:solr:start
rake db:drop db:create db:migrate db:seed RAILS_ENV=development
RAILS_ENV=development rake sunspot:solr:reindex
