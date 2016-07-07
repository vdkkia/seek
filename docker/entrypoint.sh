#!/bin/bash

# Change secret token
sed -i "s/secret_token = '.*'/key = '"`bundle exec rake secret`"'/" config/initializers/secret_token.rb
chown app:app config/initializers/secret_token.rb

# DB
soffice --headless --accept="socket,host=127.0.0.1,port=8100;urp;" --nofirststartwizard > /dev/null 2>&1 &

# Workers
sudo -Hu app bash -c "bundle exec rake seek:workers:start RAILS_ENV=production"

# Search
sudo -Hu app bash -c "bundle exec rake sunspot:solr:start RAILS_ENV=production"


/sbin/my_init
