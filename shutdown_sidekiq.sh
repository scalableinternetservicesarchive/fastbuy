#!/bin/bash

bundle exec sidekiqctl stop tmp/pids/sidekiq.pid 5
$REDIS_PATH/redis-cli shutdown

