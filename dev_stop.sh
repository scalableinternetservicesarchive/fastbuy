if ps -ef | grep solr | grep -q development; then
  rake sunspot:solr:stop RAILS_ENV=development
fi
if ps -ef | grep solr | grep -q test; then
  rake sunspot:solr:stop RAILS_ENV=test
fi
if ps -ef | grep delayed | grep -q job; then
  RAILS_ENV=development bin/delayed_job stop
fi

