#To run
#sh dev_test.sh

RAILS_ENV=test rake sunspot:solr:start

RAILS_ENV=test source ./start_sidekiq.sh
rake test
