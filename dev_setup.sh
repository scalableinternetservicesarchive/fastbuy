#To run:
#sh dev_setup.sh

RAILS_ENV=test rake sunspot:solr:start
rake db:drop db:migrate db:seed RAILS_ENV=development
rake db:migrate RAILS_ENV=test
