#To run
#sh dev_test.sh

RAILS_ENV=test rake sunspot:solr:start
rake test
