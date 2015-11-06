# Setup Production Mode
# To run
# . pro_solr.sh
# Notice: In VM, you need to install mariadb and start the service. Otherwise you will get ERROR: Can't connect to local MySQL server through socket '/var/lib/mysql/mysql.sock'.

# sudo yum install mariadb mariadb-server
sudo systemctl start mariadb.service

rake sunspot:solr:stop RAILS_ENV=production
rake sunspot:solr:start RAILS_ENV=production
rake assets:precompile RAILS_ENV=production
export SECRET_KEY_BASE=$(rake secret RAILS_ENV=production)
bash start_sidekiq.sh
