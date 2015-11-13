if ps -ef | grep solr | grep -q production; then
  rake sunspot:solr:stop RAILS_ENV=production
fi
if ps -ef | grep delayed | grep -q job; then
  RAILS_ENV=production bin/delayed_job stop
fi

