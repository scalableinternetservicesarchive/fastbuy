#!/bin/sh
#To run:
#sh database_setup.sh

rake db:migrate:reset db:seed
