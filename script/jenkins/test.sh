#!/bin/sh

source "$HOME/.rvm/scripts/rvm"

RUBY_VERSION=$(cat .ruby-version)
GEMSET=$(cat .ruby-gemset)

rvm use "$RUBY_VERSION@$GEMSET"

set -e

gem install bundler

bundle install

rake -T
