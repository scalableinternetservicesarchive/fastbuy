if ps -ef | grep solr | grep -q production; then
  rake sunspot:solr:stop RAILS_ENV=production
fi
if ps -ef | grep redis | grep -q server; then
  . shutdown_sidekiq.sh
fi
