#!/bin/bash
# To run
# . dev_test.sh
if ps -ef | grep solr | grep test | awk '{$2}'; then
  echo Solr Test is running!
else
  rake sunspot:solr:start RAILS_ENV=test 
fi
rake test RAILS_ENV=test
