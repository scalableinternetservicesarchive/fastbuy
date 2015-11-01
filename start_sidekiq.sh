#!/bin/bash

export REDIS_PATH=$HOME/redis-stable/src

echo "Starting Redis..."
$REDIS_PATH/redis-server > /dev/null 2>&1 &
#sleep 3
echo "Starting Sidekiq..."
bundle exec sidekiq -q default -q mailers > /dev/null 2>&1 &
#sleep 3

