# Setup Production Mode
# To run
# . pro_solr.sh
# Notice: In VM, you need to install mariadb and start the service. Otherwise you will get ERROR: Can't connect to local MySQL server through socket '/var/lib/mysql/mysql.sock'.

# sudo yum install mariadb mariadb-server
sudo systemctl start mariadb.service

if ! [ -z "$SECRET_KEY_BASE" ]; then
  echo Generating Secret Key...
  export SECRET_KEY_BASE=$(rake secret RAILS_ENV=production)
fi
if ps -ef | grep solr | grep -q production; then
  echo Solr Production is running!
else
  rake sunspot:solr:start RAILS_ENV=production
fi
if ps -ef | grep redis | grep -q server; then
  echo Redis is running!
else
  export REDIS_PATH=$PWD/../redis-stable/src
  bash start_sidekiq.sh
fi
rake assets:precompile RAILS_ENV=production
