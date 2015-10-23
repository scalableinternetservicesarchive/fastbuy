#To run:
#sh dev_setup.sh

rake db:drop db:migrate db:seed RAILS_ENV=development
rake db:migrate RAILS_ENV=test
