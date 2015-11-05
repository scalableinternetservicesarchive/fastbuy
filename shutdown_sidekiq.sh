#!/bin/bash

export REDIS_PATH=$HOME/redis-stable/src

bundle exec sidekiqctl stop tmp/pids/sidekiq.pid 5
$REDIS_PATH/redis-cli shutdown

