# Start Solr Server in Development Mode
# To run:
# . dev_service.sh
# Notice: In VM, the env is development as default.
if ps -ef | grep solr | grep -q development; then
  echo Solr Development is running!
else
  rake sunspot:solr:start RAILS_ENV=development
fi
if ps -ef | grep redis | grep -q server; then
  echo Redis is running!
else
  export REDIS_PATH=$PWD/../redis-stable/src
  bash start_sidekiq.sh
fi
