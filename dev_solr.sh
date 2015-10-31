# Start Solr Server in Development Mode
# To run:
# sh dev_solr.sh or . dev_solr.sh
# Notice: In VM, the env is development as default.

rake sunspot:solr:stop RAILS_ENV=development 
rake sunspot:solr:start RAILS_ENV=development 
sleep 5
