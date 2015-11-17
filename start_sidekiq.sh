#!/bin/bash

echo "Starting Redis..."
echo "Redis path is:"
echo $REDIS_PATH
$REDIS_PATH/redis-server > /dev/null 2>&1 &
#sleep 3
echo "Starting Sidekiq..."
bundle exec sidekiq > /dev/null 2>&1 &
#sleep 3

