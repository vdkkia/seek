#!/bin/bash

. "$HOME/.rvm/scripts/rvm"

# RUBY_VERSION=$(cat .ruby-version)
# GEMSET=$(cat .ruby-gemset)

# force 2.2.7 for now - problem compiling 2.2.8 on Debian Stretch
# RUBY_VERSION="ruby-2.4"

# rvm use "$RUBY_VERSION@$GEMSET"

set -e

gem install bundler

bundle install

cp script/jenkins/database.sqlite3.yml config/database.yml

bundle exec rake db:setup

bundle exec rake db:test:prepare

bundle exec rake test:units
