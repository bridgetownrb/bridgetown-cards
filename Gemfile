source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Hello! This is where you manage which Bridgetown version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Bridgetown with `bundle exec`, like so:
#
#   bundle exec bridgetown serve
#
# This will help ensure the proper Bridgetown version is running.
#
# To install a plugin, simply run bundle add and specify the group
# "bridgetown_plugins". For example:
#
#   bundle add some-new-plugin -g bridgetown_plugins
#
# Happy Bridgetowning!

gem "bridgetown", "~> 1.0.0.alpha11"
gem "bridgetown-core", github: "bridgetownrb/bridgetown", branch: "esbuild-bundling", ref: "d632a8e162a7587000fa4bd1e69b13009551eedd"

# Puma is a Rack-compatible server
# (you can optionally limit this to the "development" group)
gem "puma", "~> 5.2"

gem "ruby2js", "~> 4.2"

gem "bridgetown-seo-tag", "~> 5.0", :group => :bridgetown_plugins
