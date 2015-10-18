#!/bin/sh
#To run:
#sh database_setup.sh

bundle
bundle exec rake db:drop
bundle exec rake db:create db:migrate

