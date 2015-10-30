# Setup Production Mode
# To run
# . pro_setup.sh
# Notice: In VM, you need to install mariadb and start the service. Otherwise you will get ERROR: Can't connect to local MySQL server through socket '/var/lib/mysql/mysql.sock'.
# Precomiple is needed for providing static files.

# sudo yum install mariadb mariadb-server 
sudo systemctl stop mariadb.service
sudo systemctl start mariadb.service

export SECRET_KEY_BASE=$(rake secret RAILS_ENV=production) 
rake sunspot:solr:stop RAILS_ENV=production
rake sunspot:solr:start RAILS_ENV=production
rake db:drop db:create db:migrate RAILS_ENV=production
rake db:seed RAILS_ENV=production
rake sunspot:reindex RAILS_ENV=production
rake assets:precompile RAILS_ENV=production
