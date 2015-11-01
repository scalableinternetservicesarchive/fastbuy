#!/bin/bash

FASTBUY_DIR=$PWD
cd ..
sudo yum install tcl
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
rm redis-stable.tar.gz
cd redis-stable
make
make test
REDIS_PATH=$PWD/src
echo $REDIS_PATH
cd $FASTBUY_DIR

