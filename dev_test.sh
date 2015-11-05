#!/bin/bash
#To run
#. dev_test.sh

export REDIS_PATH=$HOME/redis-stable/src

if ! [ -z "$FIRST" ]; then
  echo "NOT FIRST TIME"
  . shutdown_sidekiq.sh
fi

RAILS_ENV=test rake sunspot:solr:start
#RAILS_ENV=test source ./start_sidekiq.sh
$REDIS_PATH/redis-server > /dev/null 2>&1 &

if [ -z "$FIRST" ]; then
  echo "FIRST TIME"
  export FIRST=T
  sleep 5
fi

rake test

