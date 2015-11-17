# Start Solr Server in Development Mode
# To run:
# . dev_service.sh
# Notice: In VM, the env is development as default.
if ps -ef | grep solr | grep -q development; then
  echo Solr development is running!
else
  rake sunspot:solr:start RAILS_ENV=development
fi
if ps -ef | grep delayed | grep -q job; then
  echo Delayed_job development is running!
else
  RAILS_ENV=development bin/delayed_job -n 2 start
fi

