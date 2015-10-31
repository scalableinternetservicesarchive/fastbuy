#To run:
#. dev_setup.sh
#Notice: In VM, the env is development as default.
#Install mysql if bundle fails.
#sudo yum install mysql-devel

RAILS_ENV=development rake sunspot:solr:stop
RAILS_ENV=development rake sunspot:solr:start
rake db:drop db:create db:migrate db:seed RAILS_ENV=development
RAILS_ENV=development rake sunspot:solr:reindex
