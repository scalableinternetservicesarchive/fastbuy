#!/bin/bash

echo "Starting Redis..."
$REDIS_PATH/redis-server > /dev/null 2>&1 &
#sleep 3
mkdir -p tmp/pids
echo "Starting Sidekiq..."
bundle exec sidekiq > /dev/null 2>&1 &
#sleep 3

